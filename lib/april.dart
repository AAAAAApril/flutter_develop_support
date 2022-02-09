import 'dart:io';

import 'package:flutter/services.dart';

class April {
  April._();

  static const MethodChannel _channel = MethodChannel(
    'April.FlutterDevelopSupport.MethodChannelName',
  );

  ///回退到桌面
  static void backToDesktop() {
    if (!Platform.isAndroid) {
      return;
    }
    _channel.invokeMethod('backToDesktop');
  }

  ///关闭应用
  static void closeApplication() {
    if (!Platform.isAndroid) {
      return;
    }
    _channel.invokeMethod('closeApplication');
  }

  ///重启应用
  static void restartApplication() {
    if (!Platform.isAndroid) {
      return;
    }
    _channel.invokeMethod('restartApplication');
  }

  ///获取链接能够跳转到的 APP 的包信息
  static Future<ComponentName?> canLaunchComponentName(String url) {
    return _channel.invokeMethod<Map>('canLaunchComponentName', {
      'url': url,
    }).then<ComponentName?>((value) {
      final String? packageName = value?['packageName'] as String?;
      final String? className = value?['className'] as String?;
      if (packageName == null || className == null || packageName.isEmpty) {
        return null;
      }
      if ('com.android.fallback' == packageName &&
          'com.android.fallback.Fallback' == className) {
        return null;
      }
      return ComponentName(
        packageName: packageName,
        className: className,
      );
    }).catchError((_) => null);
  }
}

class ComponentName {
  const ComponentName({
    required this.packageName,
    required this.className,
  });

  ///包名
  final String packageName;

  ///类名
  final String className;

  @override
  String toString() {
    return 'ComponentName{packageName: $packageName, className: $className}';
  }
}
