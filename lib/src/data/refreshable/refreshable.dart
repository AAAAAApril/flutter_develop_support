import 'package:april_flutter_utils/src/data/value_notifier/cacheable_value_listenable.dart';
import 'package:april_flutter_utils/src/data/value_notifier/notifiable_value_notifier.dart';

import 'package:flutter/foundation.dart';

part 'refreshable_config.dart';

part 'refreshable_controller.dart';

part 'refreshable_data_wrapper.dart';

part 'refreshable_state_value.dart';

part 'simple/simple_refreshable_controller.dart';

///可刷新功能超类
abstract class Refreshable<T> {
  ///绑定的数据列
  final NotifiableValueNotifier<List<T>> _data = NotifiableValueNotifier<List<T>>(<T>[]);

  ValueListenable<List<T>> get data {
    onGetDataListenable(_data.value);
    return _data;
  }

  List<T> get dataValue => List<T>.of(_data.value);

  ///刷新状态值
  @protected
  final CacheableValueNotifier<RefreshableStateValue> refreshableStateInternal =
      CacheableValueNotifier<RefreshableStateValue>(
    const RefreshableStateValue.def(),
    maxCacheCount: 5,
  );

  CacheableValueListenable<RefreshableStateValue> get refreshableState => refreshableStateInternal;

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

  ///重置第一次刷新状态
  @protected
  void resetRefreshedOnce() {
    refreshableStateInternal.value = refreshableStateInternal.value.copyWith(
      isRefreshedOnce: false,
    );
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
