import 'package:flutter/foundation.dart';

///分页基础功能超类
mixin Pagination<T> {
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

  ///是否正在加载更多
  final ValueNotifier<bool> _isLoadingMore = ValueNotifier<bool>(false);

  ValueListenable<bool> get isLoadingMore => _isLoadingMore;

  ///是否还有更多数据
  final ValueNotifier<bool> _hasMoreData = ValueNotifier<bool>(false);

  ValueListenable<bool> get hasMoreData => _hasMoreData;

  ///正在获取数据监听器
  @protected
  void onGetDataListenable(List<T> oldData) {
    //do something
  }

  ///设置是否正在刷新
  @protected
  void setRefreshing(bool refreshing) {
    _isRefreshing.value = refreshing;
  }

  ///设置是否正在加载更多
  @protected
  void setLoadingMore(bool loading) {
    _isLoadingMore.value = loading;
  }

  ///设置是否还有更多数据
  @protected
  void setHasMoreData(bool hasMore) {
    _hasMoreData.value = hasMore;
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

  ///清空数据
  void clearData() {
    setData(<T>[]);
  }

  ///刷新操作
  Future<void> refresh();

  ///加载更多操作
  Future<void> loadMore();

  ///释放资源
  @mustCallSuper
  void dispose() {
    _data.dispose();
    _isRefreshing.dispose();
    _isLoadingMore.dispose();
    _hasMoreData.dispose();
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
