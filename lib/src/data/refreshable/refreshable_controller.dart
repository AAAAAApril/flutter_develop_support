part of 'refreshable.dart';

///刷新列表控制器
abstract class AbsRefreshableController<T, W extends AbsRefreshableDataWrapper<T>> extends Refreshable<T> {
  AbsRefreshableController({
    RefreshableConfig config = const RefreshableConfig(),
  }) : refreshableConfig = config {
    if (!refreshableStateInternal.value.isRefreshedOnce &&
        refreshableConfig.autoRefresh &&
        !refreshableConfig.lazyRefresh) {
      refresh();
    }
  }

  ///配置参数
  final RefreshableConfig refreshableConfig;

  @protected
  @override
  void onGetDataListenable(List<T> oldData) {
    if (!refreshableStateInternal.value.isRefreshedOnce &&
        refreshableConfig.autoRefresh &&
        refreshableConfig.lazyRefresh) {
      refresh();
    }
    //如果已经刷新过了，但是列表为空，触发一次刷新操作
    else if (refreshableStateInternal.value.isRefreshedOnce &&
        oldData.isEmpty &&
        refreshableConfig.autoRefreshOnEmptyList) {
      refresh();
    }
  }

  ///刷新操作
  @override
  @mustCallSuper
  Future<void> refresh() async {
    //正在刷新时不允许触发刷新操作
    if (refreshableStateInternal.value.isRefreshing) {
      return;
    }
    await _refresh();
  }

  ///刷新操作真实执行函数
  Future<void> _refresh() async {
    setRefreshing(true);
    //加载数据
    try {
      final wrapper = await refreshInternal();
      if (wrapper.succeed) {
        if (refreshableConfig.notifyStateFirst) {
          setRefreshSucceed(true);
        }
        await onRefreshSucceed(wrapper);
        if (!refreshableConfig.notifyStateFirst) {
          setRefreshSucceed(true);
        }
      } else {
        if (refreshableConfig.notifyStateFirst) {
          setRefreshSucceed(false);
        }
        await onRefreshFailed(wrapper);
        if (!refreshableConfig.notifyStateFirst) {
          setRefreshSucceed(false);
        }
      }
    } catch (_) {
      //do something
    } finally {
      setRefreshing(false);
    }
  }

  ///刷新成功
  @protected
  @mustCallSuper
  Future<void> onRefreshSucceed(covariant W wrapper) async {
    setData(
      await onInterceptAllData(
        await onInterceptNewData(wrapper.data),
      ),
    );
  }

  ///刷新失败
  @protected
  @mustCallSuper
  Future<void> onRefreshFailed(covariant W wrapper) async {
    // do something
  }

  ///拦截数据（可以做筛选、排序等操作，但如果数据量过大，排序操作可能导致界面卡顿。可以新开个线程处理）
  ///[data] 是新获取到的值，不包含缓存的数据
  Future<List<T>> onInterceptNewData(final List<T> data) async {
    return data;
  }

  ///拦截数据（可以做筛选、排序等操作，但如果数据量过大，排序操作可能导致界面卡顿。可以新开个线程处理）
  ///[data] 是包含了本地缓存的所有数据（刷新操作时，本地数据缓存不会参与进来）
  Future<List<T>> onInterceptAllData(final List<T> data) async {
    return data;
  }

  ///刷新操作的具体执行方法
  @protected
  Future<W> refreshInternal();
}
