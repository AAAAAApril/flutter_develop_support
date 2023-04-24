import 'package:april_flutter_utils/april.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

///能够监听 内部 Widget 可见性变化的组件
class VisibilityDetectorWidget extends StatelessWidget {
  const VisibilityDetectorWidget({
    Key? key,
    required this.detectorKey,
    required this.child,
    required this.visibilityNotifier,
    this.sliverWidget = false,
  }) : super(key: key);

  ///监听器的 Key
  final Key detectorKey;

  ///可见性数值变更监听器
  final VisibilityValueNotifier visibilityNotifier;

  ///是否是 Sliver 类型的组件
  final bool sliverWidget;

  ///内嵌的组件
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (sliverWidget) {
      return SliverVisibilityDetector(
        key: detectorKey,
        onVisibilityChanged: visibilityNotifier._onVisibilityChanged,
        sliver: child,
      );
    }
    return VisibilityDetector(
      key: detectorKey,
      onVisibilityChanged: visibilityNotifier._onVisibilityChanged,
      child: child,
    );
  }
}

class VisibilityValue {
  const VisibilityValue({
    required this.appVisible,
    required this.widgetVisible,
  });

  const VisibilityValue.def()
      :
        //应用默认可见
        appVisible = true,
        //组件默认不不可见
        widgetVisible = false;

  final bool appVisible;
  final bool widgetVisible;

  VisibilityValue copyWith({
    bool? appVisible,
    bool? widgetVisible,
  }) =>
      VisibilityValue(
        appVisible: appVisible ?? this.appVisible,
        widgetVisible: widgetVisible ?? this.widgetVisible,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisibilityValue &&
          runtimeType == other.runtimeType &&
          widgetVisible == other.widgetVisible &&
          appVisible == other.appVisible;

  @override
  int get hashCode => widgetVisible.hashCode ^ appVisible.hashCode;
}

class VisibilityValueNotifier extends ValueNotifier<VisibilityValue>
    with WidgetsBindingObserver {
  ///只要 Widget 有一像素可见，则认定为 Widget 可见
  static bool _checkWidgetVisible(VisibilityInfo info) =>
      info.visibleFraction != 0;

  VisibilityValueNotifier({
    VisibilityValue defaultValue = const VisibilityValue.def(),
    this.isWidgetVisible = _checkWidgetVisible,
  }) : super(defaultValue) {
    _visible = TransformableValueNotifier<VisibilityValue, bool>(
      source: this,
      transformer: (sourceValue) =>
          sourceValue.appVisible && sourceValue.widgetVisible,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _visible.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ///综合 App 以及 Widget 是否可见
  late final ValueNotifier<bool> _visible;

  ValueListenable<bool> get visible => _visible;

  ///判断 Widget 是否可见的回调
  final bool Function(VisibilityInfo info) isWidgetVisible;

  /// Widget 可见性变更
  void _onVisibilityChanged(VisibilityInfo info) {
    value = value.copyWith(
      widgetVisible: isWidgetVisible(info),
    );
  }

  /// App 可见性变更
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        value = value.copyWith(
          appVisible: true,
        );
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        value = value.copyWith(
          appVisible: false,
        );
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
}
