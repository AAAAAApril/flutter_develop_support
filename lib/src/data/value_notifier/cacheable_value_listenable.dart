import 'package:flutter/foundation.dart';

abstract class CacheableValueListenable<T> extends ValueListenable<T> {
  const CacheableValueListenable() : super();

  ///最大缓存数量（超过数量时，新覆盖旧）
  int get maxCacheCount;

  ///更新过的次数（不包括默认值）
  int get updatedCount;

  ///缓存的值
  ///最后一个值为上一次赋值的，而不是最新
  List<T> get cachedValues;
}

///会缓存设置过的值的 [ValueNotifier]
class CacheableValueNotifier<T> extends ChangeNotifier implements CacheableValueListenable<T> {
  CacheableValueNotifier(
    this._value, {
    //默认最大缓存 3 个，算上最新的，一共有 4 个可用值。
    int maxCacheCount = 3,
  }) :
        //至少缓存一个值，确保始终有 2 个可用值
        maxCacheCount = maxCacheCount < 1 ? 1 : maxCacheCount;

  @override
  final int maxCacheCount;

  int _updatedCount = 0;

  @override
  int get updatedCount => _updatedCount;

  final List<T> _cachedValues = <T>[];

  @override
  List<T> get cachedValues => _cachedValues;

  @override
  T get value => _value;
  T _value;

  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _updatedCount++;
    final T old = _value;
    _value = newValue;
    _cache(old);
    notifyListeners();
  }

  ///清空缓存
  void clearCaches() {
    _cachedValues.clear();
  }

  void _cache(T oldValue) {
    _cachedValues.add(oldValue);
    //当缓存数量超过最大值时
    if (_cachedValues.length > maxCacheCount) {
      //仅保留最大值个数
      _cachedValues
          //移除第一个
          .removeAt(0);
    }
  }

  @override
  String toString() => '${describeIdentity(this)}('
      'currentValue:$value,'
      'maxCacheCount:$maxCacheCount,'
      'updatedCount:$_updatedCount,'
      'currentCacheCount:${_cachedValues.length}'
      ')';
}
