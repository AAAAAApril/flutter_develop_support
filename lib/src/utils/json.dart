typedef DecodeMapValue<T> = T Function(Map map);

///从 json 字符串中取值时，可以用这个工具类协助，处理一些小问题
class Json {
  const Json(this.value);

  final dynamic value;

  Object? get(String key) {
    if (value == null || value is! Map) {
      return null;
    }
    return value[key];
  }

  String getString(
    String key, {
    String defaultValue = '',
  }) {
    Object? value = get(key);
    if (value == null) {
      return defaultValue;
    }
    if (value is String) {
      return value;
    }
    return value.toString();
  }

  List<String> getStringList(String key) {
    Object? value = get(key);
    if (value == null) {
      return <String>[];
    }
    if (value is! List) {
      if (value is String && value.isNotEmpty) {
        return <String>[value];
      } else {
        return <String>[];
      }
    }
    if (value.isEmpty) {
      return <String>[];
    }
    return value
        .where((element) => element != null)
        .map<String>((e) => e.toString())
        .toList();
  }

  int? getNullableInt(String key) {
    Object? value = get(key);
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }

  int getInt(
    String key, {
    int defaultValue = 0,
  }) {
    return getNullableInt(key) ?? defaultValue;
  }

  List<int> getIntList(String key) {
    Object? value = get(key);
    if (value == null) {
      return <int>[];
    }
    if (value is! List) {
      if (value is int) {
        return <int>[value];
      } else if (value is num) {
        return <int>[value.toInt()];
      } else {
        return <int>[];
      }
    }
    if (value.isEmpty) {
      return <int>[];
    }
    return value
        .map<int?>((e) {
          if (e == null) {
            return null;
          }
          if (e is int) {
            return e;
          }
          if (e is num) {
            return e.toInt();
          }
          return int.tryParse(e.toString());
        })
        .where((element) => element != null)
        .map<int>((e) => e!)
        .toList();
  }

  double? getNullableDouble(String key) {
    Object? value = get(key);
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  double getDouble(
    String key, {
    double defaultValue = 0.0,
  }) {
    return getNullableDouble(key) ?? defaultValue;
  }

  List<double> getDoubleList(String key) {
    Object? value = get(key);
    if (value == null) {
      return <double>[];
    }
    if (value is! List) {
      if (value is double) {
        return <double>[value];
      } else if (value is num) {
        return <double>[value.toDouble()];
      } else {
        return <double>[];
      }
    }
    if (value.isEmpty) {
      return <double>[];
    }
    return value
        .map<double?>((e) {
          if (e == null) {
            return null;
          }
          if (e is double) {
            return e;
          }
          if (e is num) {
            return e.toDouble();
          }
          return double.tryParse(e.toString());
        })
        .where((element) => element != null)
        .map<double>((e) => e!)
        .toList();
  }

  bool? getNullableBool(
    String key, {
    //这个 int 值将会被判定为 true，其他则为 false
    int trueInt = 1,
    //这个 String 值将会被判定为 true，其他则为 false
    String trueString = 'true',
  }) {
    Object? value = get(key);
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return trueString == value;
    }
    if (value is int) {
      return value == trueInt;
    }
    return null;
  }

  bool getBool(
    String key, {
    bool defaultValue = false,
    //这个 int 值将会被判定为 true，其他则为 false
    int trueInt = 1,
    //这个 String 值将会被判定为 true，其他则为 false
    String trueString = 'true',
  }) {
    return getNullableBool(
          key,
          trueInt: trueInt,
          trueString: trueString,
        ) ??
        defaultValue;
  }

  List<bool> getBoolList(
    String key, {
    //这个 int 值将会被判定为 true，其他则为 false
    int trueInt = 1,
    //这个 String 值将会被判定为 true，其他则为 false
    String trueString = 'true',
  }) {
    Object? value = get(key);
    if (value == null) {
      return <bool>[];
    }
    if (value is! List) {
      if (value is bool) {
        return <bool>[value];
      } else if (value is String) {
        return <bool>[trueString == value];
      } else if (value is int) {
        return <bool>[value == trueInt];
      } else {
        return <bool>[];
      }
    }
    if (value.isEmpty) {
      return <bool>[];
    }
    return value
        .map<bool?>((e) {
          if (e == null) {
            return null;
          }
          if (e is bool) {
            return e;
          }
          if (e is String) {
            return trueString == e;
          }
          if (e is int) {
            return e == trueInt;
          }
          return null;
        })
        .where((element) => element != null)
        .map<bool>((e) => e!)
        .toList();
  }

  T? getTNullable<T>(
    String key, {
    required DecodeMapValue<T> decoder,
  }) {
    Object? value = get(key);
    if (value == null || value is! Map) {
      return null;
    }
    return decoder.call(value);
  }

  List<T> getMapList<T>(
    String key, {
    required T Function(Map map) decoder,
  }) {
    Object? value = get(key);
    if (value == null || value is! List) {
      return <T>[];
    }
    if (value.isEmpty) {
      return <T>[];
    }
    return value
        .map<T?>((e) {
          if (e == null || e is! Map) {
            return null;
          }
          return decoder.call(e);
        })
        .where((element) => element != null)
        .map<T>((e) => e!)
        .toList();
  }
}
