import 'package:flutter/foundation.dart';

///可刷新功能超类
abstract class Refreshable<T> {
  ///绑定的数据列
  final _ValueNotifier<List<T>> _data = _ValueNotifier<List<T>>(<T>[]);

  ValueListenable<List<T>> get data {
    onGetDataListenable(_data.value);
    return _data;
  }

  List<T> get dataValue => _data.value;

  ///是否正在刷新
  final ValueNotifier<bool> _isRefreshing = ValueNotifier<bool>(false);

  ValueListenable<bool> get isRefreshing => _isRefreshing;

  ///正在获取数据监听器
  @protected
  void onGetDataListenable(List<T> oldData) {
    //do something
  }

  ///设置新数据
  @protected
  void setData(List<T> newData) {
    _data.value = newData;
  }

  ///设置新数据，但是不通知更新
  void setDataWithoutNotify(List<T> newData) {
    _data.setValueWithoutNotify(newData);
  }

  ///设置是否正在刷新
  @protected
  void setRefreshing(bool refreshing) {
    _isRefreshing.value = refreshing;
  }

  ///刷新操作
  Future<void> refresh();

  ///清空数据
  void clearData() {
    setData(<T>[]);
  }

  ///释放资源
  @mustCallSuper
  void dispose() {
    _data.dispose();
    _isRefreshing.dispose();
  }
}

class _ValueNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  _ValueNotifier(this._value);

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
