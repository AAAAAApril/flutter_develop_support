import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///光照区域
class LightRegion extends StatefulWidget {
  const LightRegion({
    super.key,
    this.lightStyle = MouseCursor.defer,
    this.hitTestBehavior,
    this.opaque = true,
    required this.child,
  });

  final MouseCursor lightStyle;
  final HitTestBehavior? hitTestBehavior;
  final bool opaque;
  final Widget child;

  @override
  State<LightRegion> createState() => _LightRegionState();
}

class _LightRegionState extends State<LightRegion> {
  final GlobalKey globalKey = GlobalKey();

  late LightTracker tracker;

  @override
  void initState() {
    super.initState();
    tracker = LightTracker();
  }

  @override
  void dispose() {
    super.dispose();
    tracker.dispose();
  }

  Future<void> onRegionChanged(Size newSize) async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    final RenderBox? box = globalKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      tracker.lightRegion = null;
      return;
    }
    final Size regionSize = box.size;
    final Offset globalPosition = box.localToGlobal(Offset.zero);
    tracker.lightRegion = Rect.fromLTWH(globalPosition.dx, globalPosition.dy, regionSize.width, regionSize.height);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedLightRegion(
      tracker,
      child: MouseRegion(
        onEnter: (event) {
          tracker
            ..lightInside = true
            ..lightPosition = event.position;
        },
        onExit: (event) {
          tracker
            ..lightInside = false
            ..lightPosition = event.position;
        },
        onHover: (event) {
          tracker.lightPosition = event.position;
        },
        cursor: widget.lightStyle,
        hitTestBehavior: widget.hitTestBehavior,
        opaque: widget.opaque,
        child: AfterLayoutWidget(
          afterLayout: onRegionChanged,
          overlay: ValueListenableBuilder<List<TrackingCat>>(
            valueListenable: tracker.trackingCatsListenable,
            builder: (context, value, child) => Stack(
              fit: StackFit.expand,
              children: value.map<Widget>((e) => e.build(context)).toList(growable: false),
            ),
          ),
          child: Builder(key: globalKey, builder: (context) => widget.child),
        ),
      ),
    );
  }
}

///猫的领地
class CatTerritory extends StatefulWidget {
  const CatTerritory({super.key, required this.cat, required this.child});

  final TrackingCat cat;
  final Widget child;

  @override
  State<CatTerritory> createState() => _CatTerritoryState();
}

class _CatTerritoryState extends State<CatTerritory> {
  final GlobalKey globalKey = GlobalKey();

  Future<void> onRegionChanged(Size newSize) async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    final RenderBox? box = globalKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      widget.cat.trackRegion = null;
      return;
    }
    final Size regionSize = box.size;
    final Offset globalPosition = box.localToGlobal(Offset.zero);
    widget.cat.trackRegion = Rect.fromLTWH(globalPosition.dx, globalPosition.dy, regionSize.width, regionSize.height);
  }

  @override
  Widget build(BuildContext context) {
    return AfterLayoutWidget(
      afterLayout: onRegionChanged,
      child: Builder(key: globalKey, builder: (context) => widget.child),
    );
  }
}

///光斑追踪器
class LightTracker extends ChangeNotifier with LazyNotifier {
  static LightTracker find(BuildContext context) {
    final InheritedLightRegion? region = context.getInheritedWidgetOfExactType<InheritedLightRegion>();
    assert(region != null, 'No LightTracker found in context.');
    return region!.tracker;
  }

  static LightTracker dependOn(BuildContext context) {
    final InheritedLightRegion? region = context.dependOnInheritedWidgetOfExactType<InheritedLightRegion>();
    assert(region != null, 'No LightTracker found in context.');
    return region!.tracker;
  }

  LightTracker();

  ///光斑可以照到的范围（全局坐标）
  Rect? _lightRegion;

  @protected
  set lightRegion(Rect? value) {
    if (_lightRegion == value) {
      return;
    }
    _lightRegion = value;
    notifyListeners();
  }

  Rect? get lightRegion => _lightRegion;

  ///光斑位置（全局坐标）
  Offset? _lightPosition;

  @protected
  set lightPosition(Offset? value) {
    if (_lightPosition == value) {
      return;
    }
    _lightPosition = value;
    notifyListeners();
  }

  Offset? get lightPosition => _lightPosition;

  ///光斑是否在范围内
  bool _lightInside = false;

  @protected
  set lightInside(bool value) {
    if (_lightInside == value) {
      return;
    }
    _lightInside = value;
    notifyListeners();
  }

  bool get lightInside => _lightInside;

  ///正在追光的猫
  final List<TrackingCat> _cats = <TrackingCat>[];

  List<TrackingCat> get trackingCats => List<TrackingCat>.unmodifiable(_cats);

  ///追光的猫监听器
  ValueNotifier<List<TrackingCat>>? _trackingCatsNotifier;

  ValueListenable<List<TrackingCat>> get trackingCatsListenable =>
      _trackingCatsNotifier ??= ValueSelector<LightTracker, List<TrackingCat>>(
        this,
        selector: (notifier) => notifier.trackingCats,
        equals: (oldValue, newValue) {
          if (oldValue.isEmpty && newValue.isEmpty) {
            return true;
          }
          if (oldValue.length != newValue.length) {
            return false;
          }
          for (int index = 0; index < oldValue.length; index++) {
            if (oldValue[index] != newValue[index]) {
              return false;
            }
          }
          return true;
        },
      );

  void addCat(TrackingCat cat) {
    if (_cats.contains(cat)) {
      return;
    }
    _cats.add(cat);
    notifyListeners();
  }

  void removeCat(TrackingCat cat) {
    if (!_cats.contains(cat)) {
      return;
    }
    _cats.remove(cat);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _trackingCatsNotifier?.dispose();
  }
}

///追光斑的猫
abstract class TrackingCat extends ChangeNotifier with LazyNotifier {
  TrackingCat(this.lightTracker) {
    lightTracker
      ..addCat(this)
      ..addListener(notifyListeners);
  }

  ///追踪的光
  final LightTracker lightTracker;

  ///追踪的范围（全局坐标）
  Rect? _trackRegion;

  @protected
  set trackRegion(Rect? value) {
    if (_trackRegion == value) {
      return;
    }
    _trackRegion = value;
    notifyListeners();
  }

  Rect? get trackRegion => _trackRegion;

  ///猫的大小
  Size? _catSize;

  @protected
  set catSize(Size? value) {
    if (_catSize == value) {
      return;
    }
    _catSize = value;
    notifyListeners();
  }

  Size? get catSize => _catSize;

  ///是否正在追光
  bool _tracking = false;

  @protected
  set tracking(bool value) {
    if (_tracking == value) {
      return;
    }
    _tracking = value;
    notifyListeners();
  }

  bool get tracking => _tracking;

  ///光斑是否在猫的领地内
  bool get lightInside {
    final Rect? trackRegion = this.trackRegion;
    final Offset? lightPosition = lightTracker.lightPosition;
    if (trackRegion != null && lightPosition != null) {
      return trackRegion.contains(lightPosition);
    } else {
      return false;
    }
  }

  ///能否看得见猫
  bool get isCatShowing => lightTracker.lightInside && lightInside && tracking;

  ValueNotifier<bool>? _catShowingNotifier;

  ValueListenable<bool> get isCatShowingListenable => _catShowingNotifier ??= ValueSelector<TrackingCat, bool>(
        this,
        selector: (notifier) => notifier.isCatShowing,
      );

  ///猫的定位（相对于整个光照区域的位置）
  ///Tips：为了避免显示猫的时候出现闪烁，尽量保证始终能计算出其位置
  Alignment? get catAlignment {
    //光照范围（全局坐标）
    final Rect? lightRegion = lightTracker.lightRegion;
    //光斑位置（全局坐标）
    final Offset? lightPosition = lightTracker.lightPosition;
    //领地范围（全局坐标）
    final Rect? catTrackRegion = trackRegion;
    //猫的大小
    final Size? catWidgetSize = catSize;
    if (lightRegion == null || lightPosition == null || catTrackRegion == null || catWidgetSize == null) {
      return null;
    }
    //将猫的身体左上角对齐到光斑位置
    Offset point = Offset(lightPosition.dx, lightPosition.dy) - lightRegion.topLeft;
    //以猫的身体中心为参照
    point = point.translate(-catWidgetSize.width / 2, -catWidgetSize.height / 2);
    //做附加偏移
    point = translateCat(point, catWidgetSize, catTrackRegion, lightRegion);
    return Alignment(
      (point.dx / (lightRegion.width - catWidgetSize.width)) * 2 - 1,
      (point.dy / (lightRegion.height - catWidgetSize.height)) * 2 - 1,
    );
  }

  ///猫的定位监听器
  ValueNotifier<Alignment?>? _catAlignmentNotifier;

  ValueListenable<Alignment?> get catAlignmentListenable =>
      _catAlignmentNotifier ??= ValueSelector<TrackingCat, Alignment?>(
        this,
        selector: (notifier) => notifier.catAlignment,
      );

  ///开始跟踪光斑
  void startTrack() {
    tracking = true;
  }

  ///停止跟踪光斑
  void stopTrack() {
    tracking = false;
  }

  ///给猫的位置做偏移
  ///[catCenter] 猫的中心点（全局坐标）
  ///[catSize] 猫的大小
  ///[catTrackRegion] 猫的领地矩形区（全局坐标）
  ///[lightRegion] 光斑的可移动区域（全局坐标）
  @protected
  Offset translateCat(Offset catCenter, Size catSize, Rect catTrackRegion, Rect lightRegion) {
    return catCenter;
  }

  ///创建猫
  @protected
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Alignment?>(
      valueListenable: catAlignmentListenable,
      builder: (context, alignment, child) {
        if (alignment != null) {
          return Align(
            alignment: alignment,
            child: child,
          );
        }
        return child!;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isCatShowingListenable,
        builder: (context, showing, child) => AnimatedOpacity(
          opacity: showing ? 1 : 0,
          duration: const Duration(milliseconds: 100),
          child: child,
        ),
        child: IgnorePointer(
          ignoring: true,
          child: AfterLayoutWidget(
            afterLayout: (value) {
              catSize = value;
            },
            child: buildCatWidget(context),
          ),
        ),
      ),
    );
  }

  ///创建猫的具体样子
  @protected
  Widget buildCatWidget(BuildContext context);

  @override
  void dispose() {
    lightTracker
      ..removeListener(notifyListeners)
      ..removeCat(this);
    super.dispose();
    _catAlignmentNotifier?.dispose();
    _catShowingNotifier?.dispose();
  }
}

class InheritedLightRegion extends InheritedNotifier<LightTracker> {
  const InheritedLightRegion(this.tracker, {super.key, required super.child});

  final LightTracker tracker;

  @override
  LightTracker? get notifier => tracker;
}

mixin LazyNotifier on ChangeNotifier {
  @override
  void notifyListeners() {
    _postDelay?.cancel();
    _postDelay = Timer(Duration.zero, () {
      if (disposed) return;
      super.notifyListeners();
    });
  }

  bool _disposed = false;

  bool get disposed => _disposed;

  Timer? _postDelay;

  @override
  void dispose() {
    _postDelay?.cancel();
    _disposed = true;
    super.dispose();
  }
}

class ValueSelector<T extends ChangeNotifier, A> extends ValueNotifier<A> {
  ValueSelector(this.notifier, {required this.selector, this.equals}) : super(selector.call(notifier)) {
    notifier.addListener(onNotifierChanged);
  }

  final T notifier;
  final bool Function(A oldValue, A newValue)? equals;
  final A Function(T notifier) selector;

  @override
  void dispose() {
    notifier.removeListener(onNotifierChanged);
    super.dispose();
  }

  void onNotifierChanged() {
    final newValue = selector.call(notifier);
    if (equals?.call(value, newValue) ?? newValue == value) {
      return;
    }
    value = newValue;
  }
}

class AfterLayoutWidget extends StatelessWidget {
  const AfterLayoutWidget({
    super.key,
    this.overlay,
    required this.afterLayout,
    required this.child,
  });

  final Widget? overlay;
  final ValueChanged<Size> afterLayout;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: LayoutBuilder(builder: (context, constraints) {
              afterLayout.call(constraints.biggest);
              return const SizedBox.shrink();
            }),
          ),
        ),
        child,
        if (overlay != null) Positioned.fill(child: overlay!),
      ],
    );
  }
}
