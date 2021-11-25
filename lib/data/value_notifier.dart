import 'package:flutter/foundation.dart';

///支持 更新值但不通知 的功能
class NotifiableValueNotifier<T> extends ChangeNotifier
    implements ValueListenable<T> {
  NotifiableValueNotifier(this._value);

  @override
  T get value => _value;
  T _value;

  set value(T newValue) {
    if (!_needNotify && _value == newValue) {
      //这里需要在  _needNotify = true  时放行
      //可以避免在重复设置值 a ，但是却需要更新时，通知无法顺利执行的问题
      return;
    }
    _needNotify = false;
    _value = newValue;
    notifyListeners();
  }

  ///是否需要更新了
  bool _needNotify = false;

  ///更新值，但是不通知更新
  void setValueWithoutNotify(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    //do not notify
    _needNotify = true;
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
