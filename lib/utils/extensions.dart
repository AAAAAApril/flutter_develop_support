import 'package:flutter/widgets.dart';

extension ListExt<T> on List<T> {
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
    final List<List<T>> newList = <List<T>>[];
    for (int index = 0, length = this.length;
        index < length;
        index += groupLength) {
      final List<T> item = <T>[this[index]];
      for (int innerIndex = 1; innerIndex < groupLength; innerIndex++) {
        final int nextIndex = index + innerIndex;
        if (nextIndex < length) {
          item.add(this[nextIndex]);
        } else {
          break;
        }
      }
      newList.add(item);
    }
    return newList;
  }

  ///对当前列表进行加倍操作
  List<T> operator *(int times) {
    //小于 1 次时，返回空列表
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
}

extension NullableListExt<T> on List<T?> {
  ///移除所有的 null 项
  List<T> removeNull({bool growable = true}) {
    return List<T>.from(this, growable: growable);
  }
}

extension InlineSpanListExt on List<InlineSpan> {
  ///在组件周围包裹组件
  ///包裹组件会多一个，多出的这一个被添加在末尾
  List<InlineSpan> wrapWithWidget({
    required Widget? Function(int length, int currentIndex)? builder,
    //是否去掉首尾的包裹组件
    bool removeFirst = false,
    //是否去掉末尾的包裹组件
    bool removeLast = false,
  }) {
    if (isEmpty) {
      return this;
    }
    final List<InlineSpan> newWidgets = <InlineSpan>[];
    for (int index = 0; index < length; index++) {
      final addedWidget =
          (index == 0 && removeFirst) ? null : builder?.call(length, index);
      if (addedWidget != null) {
        newWidgets.add(WidgetSpan(child: addedWidget));
      }
      newWidgets.add(this[index]);
    }
    final lastWidget = removeLast ? null : builder?.call(length, length);
    if (lastWidget != null) {
      newWidgets.add(WidgetSpan(child: lastWidget));
    }
    return newWidgets;
  }
}

extension WidgetListExt on List<Widget> {
  ///在组件周围包裹组件
  ///包裹组件会多一个，多出的这一个被添加在末尾
  List<Widget> wrapWithWidget({
    required Widget? Function(int length, int currentIndex)? builder,
    //是否去掉首尾的包裹组件
    bool removeFirst = false,
    //是否去掉末尾的包裹组件
    bool removeLast = false,
  }) {
    if (isEmpty) {
      return this;
    }
    final List<Widget> newWidgets = <Widget>[];
    for (int index = 0; index < length; index++) {
      final addedWidget =
          (index == 0 && removeFirst) ? null : builder?.call(length, index);
      if (addedWidget != null) {
        newWidgets.add(addedWidget);
      }
      newWidgets.add(this[index]);
    }
    final lastWidget = removeLast ? null : builder?.call(length, length);
    if (lastWidget != null) {
      newWidgets.add(lastWidget);
    }
    return newWidgets;
  }
}

extension ColorListExt on List<Color> {
  List<Color> withOpacity(double opacity) {
    return map<Color>((e) => e.withOpacity(opacity)).toList();
  }
}

extension NullableMapExt<T, D> on Map<T, D?> {
  Map<T, D> removeNullValue() {
    return Map<T, D>.from(this);
  }
}

extension IntExt on int {
  ///对个位数的 int 进行补 0 操作（只对正数生效）
  String get twoDigits {
    if (this >= 0 && this < 10) {
      return '0$this';
    }
    return toString();
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
  ///从文件路径中获取文件名
  String fileNameFromPath() {
    return substring(lastIndexOf('/') + 1, length);
  }
}

///仿 Kotlin 高阶函数 扩展函数
extension ObjectExt<T extends Object> on T {
  D let<D>(D Function(T it) let) {
    return let.call(this);
  }
}
