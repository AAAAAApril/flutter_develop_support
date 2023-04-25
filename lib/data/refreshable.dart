import 'package:flutter/foundation.dart';

///可刷新功能超类
abstract class Refreshable<T> {
  ///绑定的数据列
  final _ValueNotifier<List<T>> _data = _ValueNotifier<List<T>>(<T>[]);

  ValueListenable<List<T>> get data {
    onGetDataListenable(_data.value);
    return _data;
  }

  List<T> get dataValue => List<T>.of(_data.value);

  ///刷新状态值
  @protected
  final ValueNotifier<RefreshableStateValue> refreshableStateInternal = ValueNotifier<RefreshableStateValue>(
    const RefreshableStateValue.def(),
  );

  ValueListenable<RefreshableStateValue> get refreshableState => refreshableStateInternal;

  ///正在获取数据监听器
  @protected
  void onGetDataListenable(List<T> oldData) {
    //do something
  }

  ///设置新数据
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
    refreshableStateInternal.value = refreshableStateInternal.value.copyWith(
      isRefreshing: refreshing,
    );
  }

  ///设置是否刷新成功
  @protected
  void setRefreshSucceed(bool succeed) {
    if (succeed) {
      refreshableStateInternal.value = refreshableStateInternal.value.copyWith(
        isRefreshedOnce: true,
        isRefreshSucceed: true,
      );
    } else {
      refreshableStateInternal.value = refreshableStateInternal.value.copyWith(
        isRefreshSucceed: false,
      );
    }
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
    refreshableStateInternal.dispose();
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

class RefreshableStateValue {
  const RefreshableStateValue({
    required this.isRefreshedOnce,
    required this.isRefreshing,
    required this.isRefreshSucceed,
  });

  const RefreshableStateValue.def()
      : isRefreshedOnce = false,
        isRefreshing = false,
        isRefreshSucceed = false;

  ///是否已经刷新过一次了（成功刷新才会计算次数）
  final bool isRefreshedOnce;

  ///是否正在刷新
  final bool isRefreshing;

  ///是否刷新成功了
  final bool isRefreshSucceed;

  RefreshableStateValue copyWith({
    bool? isRefreshedOnce,
    bool? isRefreshing,
    bool? isRefreshSucceed,
  }) =>
      RefreshableStateValue(
        isRefreshedOnce: isRefreshedOnce ?? this.isRefreshedOnce,
        isRefreshing: isRefreshing ?? this.isRefreshing,
        isRefreshSucceed: isRefreshSucceed ?? this.isRefreshSucceed,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefreshableStateValue &&
          runtimeType == other.runtimeType &&
          isRefreshedOnce == other.isRefreshedOnce &&
          isRefreshing == other.isRefreshing &&
          isRefreshSucceed == other.isRefreshSucceed;

  @override
  int get hashCode => isRefreshedOnce.hashCode ^ isRefreshing.hashCode ^ isRefreshSucceed.hashCode;
}
