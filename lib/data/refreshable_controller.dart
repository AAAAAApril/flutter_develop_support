import 'package:april/data/refreshable.dart';
import 'package:flutter/foundation.dart';

import 'refreshable_data_wrapper.dart';

///刷新列表控制器
abstract class AbsRefreshableController<T,
    W extends AbsRefreshableDataWrapper<T>> implements Refreshable<T> {
  AbsRefreshableController({
    //默认的数据
    List<T>? data,
    //是否自动触发一次刷新
    bool autoRefresh = true,
    //是否懒刷新，即：在第一获取数据监听器时触发刷新
    bool lazyRefresh = true,
    //获取数据监听器其时，发现数据量为空，是否触发刷新
    bool autoRefreshOnEmptyList = true,
  })  : _autoRefreshOnEmptyList = autoRefreshOnEmptyList,
        _autoRefresh = autoRefresh,
        _lazyRefresh = lazyRefresh {
    if (data != null) {
      setData(data);
    }
    if (!firstRefreshed && _autoRefresh && !_lazyRefresh) {
      refresh();
    }
  }

  ///是否自动触发一次刷新
  final bool _autoRefresh;

  ///是否懒刷新，如果是，则在第一次获取数据监听器的时候刷新
  ///否则，则在构造函数内刷新。
  ///当 [_autoRefresh] 为 true 时生效
  final bool _lazyRefresh;

  ///获取数据监听器其时，发现数据量为空，是否触发刷新
  final bool _autoRefreshOnEmptyList;

  ///是否已经刷新过一次了
  @protected
  bool firstRefreshed = false;

  @protected
  @override
  void onGetDataListenable(List<T> oldData) {
    if (!firstRefreshed && _autoRefresh && _lazyRefresh) {
      refresh();
    }
    //如果已经刷新过了，但是列表为空，触发一次刷新操作
    else if (firstRefreshed && oldData.isEmpty && _autoRefreshOnEmptyList) {
      refresh();
    }
  }

  ///刷新操作
  @override
  @mustCallSuper
  Future<void> refresh() async {
    //正在刷新时不允许触发刷新操作
    if (isRefreshing.value) {
      return;
    }
    await _paginationRefresh();
  }

  ///刷新操作真实执行函数
  Future<void> _paginationRefresh() async {
    setRefreshing(true);
    firstRefreshed = true;
    //加载数据
    await refreshInternal().then<void>((wrapper) async {
      if (wrapper.succeed) {
        //当前页码赋值为初始值
        await onRefreshSucceed(wrapper);
      } else {
        await onRefreshFailed(wrapper);
      }
    }).catchError((e, trace) {
      //do something
    }).whenComplete(() {
      setRefreshing(false);
    });
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
    //do something
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
