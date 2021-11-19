import 'package:flutter/foundation.dart';

import 'Pagination.dart';
import 'pagination_data_wrapper.dart';

///分页列表控制器
///所有的分页列表的刷新以及加载更多逻辑都应该继承此类处理
///[T] 绑定的数据类型
abstract class AbsPaginationController<T, W extends PaginationDataWrapper<T>>
    with Pagination<T> {
  AbsPaginationController({
    //默认的数据
    List<T>? data,
    //是否自动触发一次刷新
    bool autoRefresh = true,
    //是否懒刷新，即：在第一获取数据监听器时触发刷新
    bool lazyRefresh = true,
    //获取数据监听器其时，发现数据量为空，是否触发刷新
    bool autoRefreshOnEmptyList = true,
    //分页起始页码
    this.startPageNum = 1,
    //每一页的数据量
    this.pageSize = 20,
  })  : assert(pageSize > 0),
        _autoRefreshOnEmptyList = autoRefreshOnEmptyList,
        _currentPageNum = startPageNum,
        _autoRefresh = autoRefresh,
        _lazyRefresh = lazyRefresh {
    if (data != null) {
      setData(data);
    }
    if (!_firstRefreshed && _autoRefresh && !_lazyRefresh) {
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
  bool _firstRefreshed = false;

  ///起始页码数
  final int startPageNum;

  ///当前页码数
  int _currentPageNum;

  int get currentPageNum => _currentPageNum;

  ///用于在加载更多操作时，获取下一页的页码
  int get nextPageNum => _currentPageNum + 1;

  ///分页时每一页的数据量
  final int pageSize;

  @override
  void onGetDataListenable(List<T> oldData) {
    if (!_firstRefreshed && _autoRefresh && _lazyRefresh) {
      refresh();
    }
    //如果已经刷新过了，但是列表为空，触发一次刷新操作
    else if (_firstRefreshed && oldData.isEmpty && _autoRefreshOnEmptyList) {
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

  ///加载更多操作
  @override
  @mustCallSuper
  Future<void> loadMore() async {
    //如果第一次刷新都还没执行过，则直接转接到刷新操作
    if (!_firstRefreshed) {
      return refresh();
    }
    //没有更多数据时不允许触发加载更多操作
    if (!hasMoreData.value) {
      return;
    }
    //正在加载更多数据时不允许触发加载更多操作
    if (isLoadingMore.value) {
      return;
    }
    await _paginationLoadMore();
  }

  ///刷新操作真实执行函数
  Future<void> _paginationRefresh() async {
    setRefreshing(true);
    if (!_firstRefreshed) {
      _firstRefreshed = true;
    }
    //加载数据
    await refreshInternal().then<void>((wrapper) async {
      if (wrapper.succeed) {
        //当前页码赋值为初始值
        _currentPageNum = startPageNum;
        setHasMoreData(wrapper.hasMore);
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

  ///加载更多真实执行函数
  Future<void> _paginationLoadMore() async {
    setLoadingMore(true);
    //加载数据
    await loadMoreInternal().then<void>((wrapper) async {
      if (wrapper.succeed) {
        _currentPageNum = nextPageNum;
        setHasMoreData(wrapper.hasMore);
        await onLoadMoreSucceed(wrapper);
      } else {
        await onLoadMoreFailed(wrapper);
      }
    }).catchError((e, trace) {
      //do something
    }).whenComplete(() {
      setLoadingMore(false);
    });
  }

  ///刷新成功
  @protected
  @mustCallSuper
  Future<void> onRefreshSucceed(final W wrapper) async {
    setData(
      await onInterceptAllData(
        await onInterceptNewData(wrapper.data),
      ),
    );
  }

  ///刷新失败
  @protected
  @mustCallSuper
  Future<void> onRefreshFailed(final W wrapper) async {
    //do something
  }

  ///加载更多成功
  @protected
  @mustCallSuper
  Future<void> onLoadMoreSucceed(final W wrapper) async {
    setData(
      await onInterceptAllData(
        List.of(dataValue)
          ..addAll(
            await onInterceptNewData(wrapper.data),
          ),
      ),
    );
  }

  ///加载更多失败
  @protected
  @mustCallSuper
  Future<void> onLoadMoreFailed(final W wrapper) async {
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

  ///加载更多操作的具体执行方法
  @protected
  Future<W> loadMoreInternal();
}
