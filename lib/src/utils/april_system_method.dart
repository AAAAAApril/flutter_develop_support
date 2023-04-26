import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:april_flutter_utils/src/utils/utils.dart';

class AprilSystemMethod {
  AprilSystemMethod._();

  ///显示输入法
  static Future<void> showInputMethod() {
    return SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  ///隐藏输入法
  static Future<void> hideInputMethod() {
    return SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  ///取消焦点
  static void clearFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  ///复制文本到剪切板
  static Future<void> copyText2Clipboard(String text) {
    return Clipboard.setData(ClipboardData(text: text));
  }

  ///从剪切板粘贴文字
  static Future<String?> pasteTextFromClipboard() {
    return Clipboard.getData('text/plain').then<String?>(
      (value) => value?.text,
    );
  }

  ///长数据量时分段打印
  static void longPrint({
    Object? Function()? value,
    String? Function()? tag,
    int limitLength = 500,
    bool printWhenDebugOnly = true,
    required void Function(String value) printValue,
  }) =>
      longPrintFunc(
        tag: tag,
        limitLength: limitLength,
        printWhenDebugOnly: printWhenDebugOnly,
        printValue: printValue,
      );
}
