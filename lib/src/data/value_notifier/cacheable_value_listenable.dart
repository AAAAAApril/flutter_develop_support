import 'package:flutter/foundation.dart';

abstract class CacheableValueListenable<T> extends ValueListenable<T> {
  const CacheableValueListenable() : super();

  ///最大缓存数量（超过数量时，新覆盖旧）
  int get maxCacheCount;

  ///缓存的值
  ///会始终比 成功赋值过的次数 少一
  ///最后一个值为上一次赋值的，而不是最新
  List<T> get cachedValues;
}

///会缓存设置过的值的 [ValueNotifier]
class CacheableValueNotifier<T> extends ChangeNotifier implements CacheableValueListenable<T> {
  CacheableValueNotifier(
    this._value, {
    //默认最大缓存 3 个，算上最新的，一共有 4 个可用值。
    this.maxCacheCount = 3,
  }) : assert(maxCacheCount > 0, 'At least one cache.');

  @override
  final int maxCacheCount;

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
    _cache(old);
    notifyListeners();
  }

  @override
  List<T> get cachedValues => _cachedValues;

  ///清空缓存
  void clearCaches() {
    _cachedValues.clear();
  }

  void _cache(T oldValue) {
    _cachedValues.add(oldValue);
    //当缓存数量超过最大值时
    if (_cachedValues.length > maxCacheCount) {
      //仅保留最大值个数
      final Iterable<T> result = _cachedValues.skip(_cachedValues.length - maxCacheCount);
      //重设数据
      _cachedValues
        ..clear()
        ..addAll(result);
    }
  }

  @override
  String toString() =>
      '${describeIdentity(this)}(current:$value,maxCacheCount:$maxCacheCount,currentCacheCount:${_cachedValues.length})';
}
