import 'package:april/route/page_visibility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@Deprecated('see VisibilityDetectorWidget')
abstract class VisibilityState<T extends StatefulWidget> extends State<T>
    with ApplicationVisibilityMixin, FlutterPageVisibilityMixin {
  late ValueNotifier<bool> _pageVisible;

  ///页面可见性监听器（只能判断当前所在路由页是否可见，不能判断某个具体的 Widget）
  ValueListenable<bool> get pageVisibilityListenable => _pageVisible;

  bool _previousVisible = false;

  bool get isPageVisible => isApplicationVisible && isFlutterPageVisible;

  @override
  void initState() {
    _pageVisible = ValueNotifier<bool>(_previousVisible);
    super.initState();
  }

  @override
  void dispose() {
    _pageVisible.dispose();
    super.dispose();
  }

  @override
  void onApplicationVisibleChanged(bool visible) {
    final bool currentVisible = isPageVisible;
    _pageVisible.value = currentVisible;
    if (_previousVisible != currentVisible) {
      _previousVisible = currentVisible;
      onPageVisibilityChanged(currentVisible);
    }
  }

  @override
  void onFlutterPageVisibleChanged(bool visible) {
    final bool currentVisible = isPageVisible;
    _pageVisible.value = currentVisible;
    if (_previousVisible != currentVisible) {
      _previousVisible = currentVisible;
      onPageVisibilityChanged(currentVisible);
    }
  }

  ///页面的可见性发生了变化
  void onPageVisibilityChanged(bool visible) {}
}

@Deprecated('use VisibilityDetectorWidget instead')
class PageVisibilityWidget extends StatefulWidget {
  const PageVisibilityWidget({
    Key? key,
    required this.child,
    this.onInitState,
    this.onDispose,
    this.onPageVisibilityChanged,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onInitState;
  final VoidCallback? onDispose;
  final ValueChanged<bool>? onPageVisibilityChanged;

  @override
  State<PageVisibilityWidget> createState() => _PageVisibilityWidgetState();
}

class _PageVisibilityWidgetState extends VisibilityState<PageVisibilityWidget> {
  @override
  void initState() {
    super.initState();
    widget.onInitState?.call();
  }

  @override
  void onPageVisibilityChanged(bool visible) {
    super.onPageVisibilityChanged(visible);
    widget.onPageVisibilityChanged?.call(visible);
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
