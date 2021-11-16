import 'package:flutter/widgets.dart';

///记得把这个监听器设置给 App
late final RouteObserver pageVisibilityRouteObserver = RouteObserver();

///监听页面的显示与隐藏状态
mixin FlutterPageVisibilityMixin<T extends StatefulWidget> on State<T>
    implements RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //监听应用内页面切换
    ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      pageVisibilityRouteObserver.subscribe(this, route as PageRoute);
    }
  }

  @override
  void dispose() {
    pageVisibilityRouteObserver.unsubscribe(this);
    super.dispose();
  }

  bool _isFlutterPageVisible = true;

  bool get isFlutterPageVisible => _isFlutterPageVisible;

  ///页面可见性变化
  void onFlutterPageVisibleChanged(bool visible);

  @override
  void didPush() {
    _isFlutterPageVisible = true;
    onFlutterPageVisibleChanged(_isFlutterPageVisible);
  }

  @override
  void didPop() {
    _isFlutterPageVisible = false;
    onFlutterPageVisibleChanged(_isFlutterPageVisible);
  }

  @override
  void didPopNext() {
    _isFlutterPageVisible = true;
    onFlutterPageVisibleChanged(_isFlutterPageVisible);
  }

  @override
  void didPushNext() {
    _isFlutterPageVisible = false;
    onFlutterPageVisibleChanged(_isFlutterPageVisible);
  }
}

///监听应用的前后台切换
mixin ApplicationVisibilityMixin<T extends StatefulWidget> on State<T>
    implements WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    //监听应用级配置变化
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  bool _isApplicationVisible = true;

  bool get isApplicationVisible => _isApplicationVisible;

  ///应用前后台切换
  void onApplicationVisibleChanged(bool visible);

  @override
  void didChangeAccessibilityFeatures() {}

  @override
  void didChangeLocales(List<Locale>? locale) {}

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    return didPushRoute(routeInformation.location!);
  }

  @override
  void didChangeMetrics() {}

  @override
  void didChangePlatformBrightness() {}

  @override
  void didChangeTextScaleFactor() {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _isApplicationVisible = true;
        onApplicationVisibleChanged(_isApplicationVisible);
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        //不能响应用户操作
        _isApplicationVisible = false;
        onApplicationVisibleChanged(_isApplicationVisible);
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void didHaveMemoryPressure() {}

  @override
  Future<bool> didPopRoute() => Future<bool>.value(false);

  @override
  Future<bool> didPushRoute(String route) => Future<bool>.value(false);
}
