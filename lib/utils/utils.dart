import 'dart:convert';

import 'package:flutter/foundation.dart';

///长数据量时分段打印
void longPrintFunc({
  Object? Function()? value,
  String? Function()? tag,
  int limitLength = 500,
  bool printWhenDebugOnly = true,
  required void Function(String value) printValue,
}) {
  if (printWhenDebugOnly && !kDebugMode) {
    return;
  }
  if (tag != null) {
    printValue(tag.call() ?? '');
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
    printValue(target);
  } else {
    var outStr = StringBuffer();
    for (var index = 0; index < target.length; index++) {
      outStr.write(target[index]);
      if (index % limitLength == 0 && index != 0) {
        printValue(outStr.toString());
        outStr.clear();
        var lastIndex = index + 1;
        if (target.length - lastIndex < limitLength) {
          printValue(target.substring(lastIndex, target.length));
          break;
        }
      }
    }
  }
}
