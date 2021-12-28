import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

///是否是 debug 状态
late final bool isDebug = () {
  bool result = false;
  assert(() {
    result = true;
    return true;
  }());
  return result;
}();

///隐藏输入法
Future<void> hideInputMethod() {
  return SystemChannels.textInput.invokeMethod('TextInput.hide');
}

///取消焦点
void clearFocus() {
  FocusManager.instance.primaryFocus?.unfocus();
}

///复制文本到剪切板
Future<void> copyText2Clipboard(String text){
  return Clipboard.setData(ClipboardData(text: text));
}