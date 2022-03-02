import 'package:flutter/widgets.dart';

import 'package:visibility_detector/visibility_detector.dart';

///能够监听 内部 Widget 可见性变化的组件
class VisibilityDetectorWidget extends StatefulWidget {
  const VisibilityDetectorWidget({
    Key? key,
    required this.detectorKey,
    required this.child,
    this.onVisibleChanged,
  }) : super(key: key);

  ///监听器的 Key
  final Key detectorKey;

  ///可见性变更通知
  final ValueChanged<bool>? onVisibleChanged;

  ///内嵌的组件
  final Widget child;

  @override
  _VisibilityDetectorWidgetState createState() =>
      _VisibilityDetectorWidgetState();
}

class _VisibilityDetectorWidgetState extends State<VisibilityDetectorWidget>
    with WidgetsBindingObserver {
  ///组件默认不不可见
  bool widgetVisible = false;

  ///应用默认可见
  bool appVisible = true;

  bool? resultVisible;

  @override
  void initState() {
    super.initState();
    checkVisible();
  }

  @override
  void didUpdateWidget(covariant VisibilityDetectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    checkVisible();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        appVisible = true;
        checkVisible();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        appVisible = false;
        checkVisible();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void checkVisible() {
    Future.delayed(Duration.zero, () {
      final bool newVisible = widgetVisible && appVisible;
      if (resultVisible != newVisible) {
        resultVisible = newVisible;
        widget.onVisibleChanged?.call(newVisible);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.detectorKey,
      onVisibilityChanged: (info) {
        widgetVisible = info.visibleFraction != 0;
        checkVisible();
      },
      child: widget.child,
    );
  }
}
