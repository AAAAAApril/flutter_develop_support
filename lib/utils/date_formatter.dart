import 'package:april_flutter_utils/utils/extensions.dart';

///时间、日期格式化工具
class DateFormatter {
  ///默认值
  static final DateFormatter defaultFormatter = DateFormatter()
    ..withType(TypeFormatter.year())
    ..withValue(ValueFormatter.minus)
    ..withType(TypeFormatter.month())
    ..withValue(ValueFormatter.minus)
    ..withType(TypeFormatter.day())
    ..withValue(ValueFormatter.space)
    ..withType(TypeFormatter.hour())
    ..withValue(ValueFormatter.colon)
    ..withType(TypeFormatter.minute())
    ..withValue(ValueFormatter.colon)
    ..withType(TypeFormatter.seconds());

  DateFormatter() : _formatValues = <_Formatter>[];

  ///用于格式化的信息列
  final List<_Formatter> _formatValues;

  ///追加类型
  void withType(TypeFormatter formatter) {
    _formatValues.add(formatter);
  }

  ///追加值
  void withValue(ValueFormatter formatter) {
    _formatValues.add(formatter);
  }

  ///格式化日期、时间
  String format(DateTime value) {
    final StringBuffer buffer = StringBuffer();
    for (var element in _formatValues) {
      if (element is TypeFormatter) {
        buffer.write(element.format(value));
      } else if (element is ValueFormatter) {
        buffer.write(element.value);
      }
    }
    return buffer.toString();
  }
}

abstract class _Formatter {
  const _Formatter();
}

abstract class TypeFormatter extends _Formatter {
  factory TypeFormatter.year({
    int digitsNumber = 4,
  }) =>
      _Year(digitsNumber);

  factory TypeFormatter.month({
    bool twoDigits = true,
  }) =>
      _Month(twoDigits);

  factory TypeFormatter.day({
    bool twoDigits = true,
  }) =>
      _Day(twoDigits);

  factory TypeFormatter.hour({
    bool twoDigits = true,
  }) =>
      _Hour(twoDigits);

  factory TypeFormatter.minute({
    bool twoDigits = true,
  }) =>
      _Minute(twoDigits);

  factory TypeFormatter.seconds({
    bool twoDigits = true,
  }) =>
      _Seconds(twoDigits);

  factory TypeFormatter.milliseconds({
    int digitsNumber = 3,
  }) =>
      _Milliseconds(digitsNumber);

  factory TypeFormatter.microseconds({
    int digitsNumber = 3,
  }) =>
      _Microseconds(digitsNumber);

  const TypeFormatter() : super();

  Object format(DateTime value);
}

abstract class ValueFormatter extends _Formatter {
  static const ValueFormatter colon = _Colon();
  static const ValueFormatter minus = _Minus();
  static const ValueFormatter space = _Space();
  static const ValueFormatter point = _Point();
  static const ValueFormatter utcMark = _UTCMark();

  const ValueFormatter(
    this._value, {
    int? times = 1,
  })  : times = (times != null && times > 0) ? times : 1,
        super();

  ///值
  final String _value;

  ///连续出现的次数
  final int times;

  String get value => _value * times;
}

//##########################################

///年份
class _Year extends TypeFormatter {
  const _Year(int digitsNumber)
      : digitsNumber = digitsNumber > 4
            ? 4
            : digitsNumber < 2
                ? 2
                : digitsNumber,
        super();

  ///位数
  final int digitsNumber;

  @override
  Object format(DateTime value) {
    final String result = value.year.fourDigits;
    switch (digitsNumber) {
      case 2:
        return result.substring(result.length - 2);
      case 3:
        return result.substring(result.length - 3);
      case 4:
        return result.substring(result.length - 4);
      default:
        return value.year;
    }
  }
}

///月份
class _Month extends TypeFormatter {
  const _Month(this.twoDigits) : super();

  ///是否是两位数
  final bool twoDigits;

  @override
  Object format(DateTime value) {
    final int month = value.month;
    if (twoDigits) {
      return month.twoDigits;
    }
    return month;
  }
}

///天数
class _Day extends TypeFormatter {
  const _Day(this.twoDigits) : super();

  ///是否是两位数
  final bool twoDigits;

  @override
  Object format(DateTime value) {
    final int day = value.day;
    if (twoDigits) {
      return day.twoDigits;
    }
    return day;
  }
}

///小时
class _Hour extends TypeFormatter {
  const _Hour(this.twoDigits) : super();

  ///是否是两位数
  final bool twoDigits;

  @override
  Object format(DateTime value) {
    final int hour = value.hour;
    if (twoDigits) {
      return hour.twoDigits;
    }
    return hour;
  }
}

///分钟
class _Minute extends TypeFormatter {
  const _Minute(this.twoDigits) : super();

  ///是否是两位数
  final bool twoDigits;

  @override
  Object format(DateTime value) {
    final int minutes = value.minute;
    if (twoDigits) {
      return minutes.twoDigits;
    }
    return minutes;
  }
}

///秒钟
class _Seconds extends TypeFormatter {
  const _Seconds(this.twoDigits) : super();

  ///是否是两位数
  final bool twoDigits;

  @override
  Object format(DateTime value) {
    final int seconds = value.second;
    if (twoDigits) {
      return seconds.twoDigits;
    }
    return seconds;
  }
}

///毫秒
class _Milliseconds extends TypeFormatter {
  const _Milliseconds(int digitsNumber)
      : digitsNumber = digitsNumber > 3
            ? 3
            : digitsNumber < 1
                ? 1
                : digitsNumber,
        super();

  ///位数
  final int digitsNumber;

  @override
  Object format(DateTime value) {
    final String result = value.millisecond.threeDigits;
    switch (digitsNumber) {
      case 1:
        return result.substring(result.length - 1);
      case 2:
        return result.substring(result.length - 2);
      case 3:
        return result.substring(result.length - 3);
      default:
        return value.millisecond;
    }
  }
}

///微秒
class _Microseconds extends TypeFormatter {
  const _Microseconds(int digitsNumber)
      : digitsNumber = digitsNumber > 3
            ? 3
            : digitsNumber < 1
                ? 1
                : digitsNumber,
        super();

  ///位数
  final int digitsNumber;

  @override
  Object format(DateTime value) {
    final String result = value.microsecond.threeDigits;
    switch (digitsNumber) {
      case 1:
        return result.substring(result.length - 1);
      case 2:
        return result.substring(result.length - 2);
      case 3:
        return result.substring(result.length - 3);
      default:
        return value.microsecond;
    }
  }
}

//##########################################

///冒号
class _Colon extends ValueFormatter {
  const _Colon({int? times}) : super(':', times: times);
}

///减号
class _Minus extends ValueFormatter {
  const _Minus({int? times}) : super('-', times: times);
}

///点号 .
class _Point extends ValueFormatter {
  const _Point({int? times}) : super('.', times: times);
}

///空格
class _Space extends ValueFormatter {
  const _Space({int? times}) : super(' ', times: times);
}

///UTC 标志
class _UTCMark extends ValueFormatter {
  const _UTCMark() : super('Z');
}
