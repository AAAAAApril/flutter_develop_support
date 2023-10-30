import 'package:extended_value_notifier/extended_value_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

///能够监听 内部 Widget 可见性变化的组件
class VisibilityDetectorWidget extends StatelessWidget {
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
  ///只要 Widget 有一像素可见，则认定为 Widget 可见
  static bool _checkWidgetVisible(VisibilityInfo info) => info.visibleFraction != 0;

  VisibilityValueNotifier({
    VisibilityValue? defaultValue,
    this.isWidgetVisible = _checkWidgetVisible,
  }) : super(
          defaultValue ??
              VisibilityValue(
                //获取当前 APP 是否可见
                appVisible: WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed,
                //默认 Widget 不可见
                widgetVisible: false,
              ),
        ) {
    _visible = TransformableValueNotifier<VisibilityValue, bool>(
      source: this,
      transformer: (sourceValue) => sourceValue.appVisible && sourceValue.widgetVisible,
    );
    _lifecycleListener = AppLifecycleListener(
      onShow: () {
        value = value.copyWith(
          appVisible: true,
        );
      },
      onHide: () {
        value = value.copyWith(
          appVisible: false,
        );
      },
      onResume: () {
        value = value.copyWith(
          appVisible: true,
        );
      },
      onPause: () {
        value = value.copyWith(
          appVisible: false,
        );
      },
    );
  }

  @override
  void dispose() {
    _dispose = true;
    _lifecycleListener.dispose();
    _visible.dispose();
    super.dispose();
  }

  ///综合 App 以及 Widget 是否可见
  late final ValueNotifier<bool> _visible;

  ValueListenable<bool> get visible => _visible;

  ///应用生命周期
  late final AppLifecycleListener _lifecycleListener;

  ///判断 Widget 是否可见的回调
  final bool Function(VisibilityInfo info) isWidgetVisible;

  bool _dispose = false;

  @protected
  @override
  set value(VisibilityValue newValue) {
    if (_dispose) {
      return;
    }
    super.value = newValue;
  }

  /// Widget 可见性变更
  void _onVisibilityChanged(VisibilityInfo info) {
    value = value.copyWith(
      widgetVisible: isWidgetVisible.call(info),
    );
  }
}
