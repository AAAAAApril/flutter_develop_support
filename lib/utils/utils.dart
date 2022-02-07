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

///显示输入法
Future<void> showInputMethod() {
  return SystemChannels.textInput.invokeMethod('TextInput.show');
}

///隐藏输入法
Future<void> hideInputMethod() {
  return SystemChannels.textInput.invokeMethod('TextInput.hide');
}

///取消焦点
void clearFocus() {
  FocusManager.instance.primaryFocus?.unfocus();
}

///复制文本到剪切板
Future<void> copyText2Clipboard(String text) {
  return Clipboard.setData(ClipboardData(text: text));
}

///从剪切板粘贴文字
Future<String?> pasteTextFromClipboard() {
  return Clipboard.getData('text/plain').then<String?>(
    (value) => value?.text,
  );
}
