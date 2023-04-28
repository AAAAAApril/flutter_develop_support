import 'package:flutter/foundation.dart';

abstract class CacheableValueListenable<T> extends ValueListenable<T> {
  const CacheableValueListenable() : super();

  ///缓存的值
  ///会始终比 成功赋值过的次数 少一
  ///最后一个值为上一次赋值的，而不是最新
  List<T> get cachedValues;
}

///会缓存设置过的值的 [ValueNotifier]
class CacheableValueNotifier<T> extends ChangeNotifier implements CacheableValueListenable<T> {
  CacheableValueNotifier(this._value);

  final List<T> _cachedValues = <T>[];

  @override
  T get value => _value;
  T _value;

  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    final T old = _value;
    _value = newValue;
    _cachedValues.add(old);
    notifyListeners();
  }

  @override
  List<T> get cachedValues => _cachedValues;

  @override
  String toString() => '${describeIdentity(this)}($value,cacheCount:${_cachedValues.length})';
}
