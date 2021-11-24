import 'package:flutter/foundation.dart';

///支持 更新值但不通知 的功能
class NoNotifyValueNotifier<T> extends ChangeNotifier
    implements ValueListenable<T> {
  NoNotifyValueNotifier(this._value);

  @override
  T get value => _value;
  T _value;

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  ///更新值，但是不通知更新
  void setValueWithoutNotify(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    //do not notify
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
