import 'package:extended_value_notifier/extended_value_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

///能够监听 内部 Widget 可见性变化的组件
class VisibilityDetectorWidget extends StatefulWidget {
  const VisibilityDetectorWidget({
    Key? key,
    required this.detectorKey,
    required this.visibilityNotifier,
    this.sliverWidget = false,
    required this.child,
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
  State<VisibilityDetectorWidget> createState() => _VisibilityDetectorWidgetState();
}

class _VisibilityDetectorWidgetState extends State<VisibilityDetectorWidget> {
  @override
  void didUpdateWidget(covariant VisibilityDetectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.detectorKey != oldWidget.detectorKey || widget.visibilityNotifier != oldWidget.visibilityNotifier) {
      widget.visibilityNotifier.value = oldWidget.visibilityNotifier.value.copyWith();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sliverWidget) {
      return SliverVisibilityDetector(
        key: widget.detectorKey,
        onVisibilityChanged: widget.visibilityNotifier.onVisibilityChanged,
        sliver: widget.child,
      );
    }
    return VisibilityDetector(
      key: widget.detectorKey,
      onVisibilityChanged: widget.visibilityNotifier.onVisibilityChanged,
      child: widget.child,
    );
  }
}

class VisibilityValue {
  const VisibilityValue({
    required this.appVisible,
    required this.widgetVisible,
  });

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

  @override
  String toString() {
    return 'VisibilityValue{appVisible: $appVisible, widgetVisible: $widgetVisible}';
  }
}

class VisibilityValueNotifier extends ValueNotifier<VisibilityValue> {
  VisibilityValueNotifier({VisibilityValue? defaultValue})
      : super(
          defaultValue ??
              VisibilityValue(
                //获取当前 APP 是否可见
                appVisible: WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed,
                //默认 Widget 不可见
                widgetVisible: false,
              ),
        ) {
    _lifecycleListener = AppLifecycleListener(
      onShow: onAppShown,
      onHide: onAppHidden,
      onResume: onAppResumed,
      onInactive: onAppInactive,
    );
  }

  @override
  void dispose() {
    _dispose = true;
    _lifecycleListener.dispose();
    _visible?.dispose();
    super.dispose();
  }

  ///综合 App 以及 Widget 是否可见
  ValueNotifier<bool>? _visible;

  ValueListenable<bool> get visible {
    return _visible ??= TransformableValueNotifier<VisibilityValue, bool>(
      source: this,
      transformer: (sourceValue) => sourceValue.appVisible && sourceValue.widgetVisible,
    );
  }

  ///应用生命周期
  late final AppLifecycleListener _lifecycleListener;

  bool _dispose = false;

  @override
  set value(VisibilityValue newValue) {
    if (_dispose) {
      return;
    }
    super.value = newValue;
  }

  @protected
  void onAppShown() {}

  @protected
  void onAppHidden() {}

  @protected
  void onAppResumed() {
    value = value.copyWith(
      appVisible: true,
    );
  }

  @protected
  void onAppInactive() {
    value = value.copyWith(
      appVisible: false,
    );
  }

  ///判断 Widget 是否可见的回调
  @protected
  bool isWidgetVisible(VisibilityInfo info) {
    return info.visibleFraction > 0;
  }

  /// Widget 可见性变更
  void onVisibilityChanged(VisibilityInfo info) {
    value = value.copyWith(
      widgetVisible: isWidgetVisible.call(info),
    );
  }
}
