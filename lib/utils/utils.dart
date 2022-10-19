import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

///是否是 debug 状态
@Deprecated(
  'use kDebugMode instead,'
  'which needs import package:flutter/foundation.dart',
)
const bool isDebug = kDebugMode;

///当前是否在 Debug 状态
const bool inDebug = kDebugMode;

///当前是否在 Release 状态
const bool inRelease = kReleaseMode;

///当前是否在 Profile 状态
const bool inProfile = kProfileMode;

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

///长数据量时分段打印
void longPrint({
  Object? Function()? value,
  String? Function()? tag,
  int limitLength = 500,
  bool printWhenDebugOnly = true,
}) {
  if (printWhenDebugOnly && !kDebugMode) {
    return;
  }
  if (tag != null) {
    _flutterPrint(tag.call() ?? '');
  }
  if (value == null) {
    return;
  }
  Object? source = value.call();
  String target;
  if (source is Map<String, dynamic>) {
    target = jsonEncode(source);
  } else {
    target = source.toString();
  }
  if (target.isEmpty) {
    return;
  }
  if (target.length < limitLength) {
    _flutterPrint(target);
  } else {
    var outStr = StringBuffer();
    for (var index = 0; index < target.length; index++) {
      outStr.write(target[index]);
      if (index % limitLength == 0 && index != 0) {
        _flutterPrint(outStr.toString());
        outStr.clear();
        var lastIndex = index + 1;
        if (target.length - lastIndex < limitLength) {
          _flutterPrint(target.substring(lastIndex, target.length));
          break;
        }
      }
    }
  }
}

void _flutterPrint(String value) {
  print(value);
}
