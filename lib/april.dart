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

}
