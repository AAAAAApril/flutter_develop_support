import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:crypto/crypto.dart';

extension IterableExt<T> on Iterable<T> {
  ///查找第一个满足要求的项，找不到则返回 null
  T? findFirst(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }

  ///查找最后一个满足要求的项，找不到则返回 null
  T? findLast(bool Function(T element) test) {
    try {
      return lastWhere(test);
    } catch (_) {
      return null;
    }
  }

  ///将一个列表进行拆分成组的操作
  ///[groupLength] 每一组的个数
  List<List<T>> asGroup(int groupLength) {
    if (length <= groupLength) {
      return <List<T>>[toList(growable: false)];
    }
    final List<List<T>> result = <List<T>>[];
    for (final item in this) {
      if (result.isEmpty) {
        result.add(<T>[]);
      }
      List<T> last = result.last;
      if (last.length == groupLength) {
        result.add(<T>[]);
        last = result.last;
      }
      last.add(item);
    }
    return result;
  }

  ///对当前列表进行加倍操作
  List<T> operator *(int times) {
    if (times < 1) {
      return <T>[];
    }
    final List<T> result = <T>[];
    do {
      result.addAll(this);
      times -= 1;
    } while (times > 0);
    return result;
  }

  ///传回 下标 和 项 的循环，并返回列表
  List<D> indexedMap<D>(D Function(T element, int index) test) {
    final List<T> current = toList(growable: false);
    final List<D> result = <D>[];
    for (int index = 0; index < current.length; index++) {
      result.add(test.call(current[index], index));
    }
    return result;
  }

  List<T> splitJoin({
    required T? Function(int length, int currentIndex)? builder,
    //是否去掉首尾的包裹组件
    bool removeFirst = false,
    //是否去掉末尾的包裹组件
    bool removeLast = false,
  }) {
    if (isEmpty) {
      return toList();
    }
    final List<T> current = toList(growable: false);
    final List<T> result = <T>[];
    for (int index = 0; index < current.length; index++) {
      final addition = (index == 0 && removeFirst) ? null : builder?.call(current.length, index);
      if (addition != null) {
        result.add(addition);
      }
      result.add(current[index]);
    }
    final lastAddition = removeLast ? null : builder?.call(current.length, current.length);
    if (lastAddition != null) {
      result.add(lastAddition);
    }
    return result;
  }
}

extension DurationListExt on Iterable<Duration> {
  ///每一个时长占总时长的权重
  List<double> weights() {
    final int totalDurationInMicroseconds = fold<Duration>(
      Duration.zero,
      (previousValue, element) => previousValue + element,
    ).inMicroseconds;
    final List<double> result = <double>[];
    forEach((element) {
      result.add(element.inMicroseconds / totalDurationInMicroseconds);
    });
    return result;
  }
}

extension NumInt on num {
  ///保留小数位数，但不 进位
  String toStringAsFixedWithoutCarryUp(int fractionDigits) {
    final String temp = toString();
    //小数点所在下标
    final int dotIndex = temp.indexOf('.');
    //没有小数点
    if (dotIndex < 0) {
      return '$temp.${'0' * fractionDigits}';
    }
    //有小数点
    else {
      return '$temp${'0' * fractionDigits}'.substring(0, dotIndex + fractionDigits + 1);
    }
  }
}

extension IntExt on int {
  ///对个位数的 int 进行补 0 操作（只对正数生效）
  String get twoDigits {
    if (this >= 0 && this < 10) {
      return '0$this';
    }
    return '$this';
  }

  ///对百位以内的 int 进行补 0 操作（只对正数生效）
  String get threeDigits {
    if (this >= 100) return "$this";
    if (this >= 10) return "0$this";
    return "00$this";
  }

  ///对千位以内的 int 进行补 0 操作
  String get fourDigits {
    int absN = abs();
    String sign = this < 0 ? "-" : "";
    if (absN >= 1000) return "$this";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }

  ///只取末尾两个数（只对正数生效）
  ///
  ///  19999 => 99
  ///  77 => 77
  ///  5 => 05
  ///
  String get endTwo {
    String result = toString();
    if (this >= 100) {
      //截取
      result = result.substring(result.length - 2);
    } else if (this >= 10) {
      //不处理
    } else {
      //左侧补 0
      result = '0$result';
    }
    return result;
  }
}

extension StringExt on String {
  ///对 字符串做 md5
  String toMD5() {
    return md5.convert(utf8.encode(this)).toString();
  }

  ///把首字母大写
  String firstWord2UpperCase() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

///仿 Kotlin 高阶函数 扩展函数
extension ObjectExt<T extends Object> on T {
  D let<D>(D Function(T it) let) {
    return let.call(this);
  }

  T apply(void Function(T it) apply) {
    apply.call(this);
    return this;
  }
}

///[BuildContext] 的扩展
extension BuildContextExt on BuildContext {
  ///安全返回
  ///
  ///当调用 pop 的 context 所属的页面不在最顶层的时候，
  ///直接调用  Navigator.pop() 会导致最顶层的页面被 pop 掉，
  ///而不是这个 context 所属的页面
  ///
  /// 所以有此 扩展
  void safetyPop<T extends Object?>({
    //如果当前页面没在最顶层，则先退回到当前页面
    bool pop2CurrentWhenNotOnTop = true,
    //需要回传给上一级路由的数据
    T? result,
  }) {
    final ModalRoute? route = ModalRoute.of(this);
    if (route == null) {
      return;
    }
    //在最顶层（正常走 pop）
    if (route.isCurrent) {
      Navigator.pop<T>(this, result);
    }
    //没在最顶层
    else {
      //退回到自己
      if (pop2CurrentWhenNotOnTop) {
        //先退回
        Navigator.popUntil(this, (value) => route == value);
        //再 pop 自己
        Navigator.pop<T>(this, result);
      }
      //不需要退回
      else {
        //移除自己
        Navigator.removeRoute(this, route);
      }
    }
  }
}
