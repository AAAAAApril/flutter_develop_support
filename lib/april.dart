import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class April {
  April._();

  static const MethodChannel _channel = MethodChannel(
    'april_method_channel_name',
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

  ///是否是 debug 状态
  static late final bool isDebug = () {
    bool result = false;
    assert(() {
      result = true;
      return true;
    }());
    return result;
  }();

  ///隐藏输入法
  static Future<void> hideInputMethod() {
    return SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  ///取消焦点
  static void clearFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
