import 'package:flutter/foundation.dart';

import 'pagination.dart';
import 'pagination_data_wrapper.dart';
import 'refreshable_controller.dart';

///分页列表控制器
///所有的分页列表的刷新以及加载更多逻辑都应该继承此类处理
///[T] 绑定的数据类型
///[N] 页码的数据类型（通常是 [int]，但也存在是其他类型的特殊情况，比如 [String]）
abstract class AbsPaginationController<T, W extends AbsPaginationDataWrapper<T>, N>
    extends _PaginationControllerInternal<T, W, N> with Pagination<T> {
  AbsPaginationController({
    required PaginationConfig<N> config,
  }) : super(paginationConfig: config);
}

///分页功能的一些配置参数
abstract class PaginationConfig<T> extends RefreshableConfig {
  PaginationConfig({
    required this.startPageNum,
    this.pageSize = 20,
    bool notifyStateFirst = true,
    bool autoRefresh = true,
    bool lazyRefresh = true,
    bool autoRefreshOnEmptyList = true,
  })  : assert(pageSize > 0),
        _currentPageNum = startPageNum,
        super(
          notifyStateFirst: notifyStateFirst,
          autoRefresh: autoRefresh,
          lazyRefresh: lazyRefresh,
          autoRefreshOnEmptyList: autoRefreshOnEmptyList,
        );

  ///起始页码数
  final T startPageNum;

  ///当前页码数
  T _currentPageNum;

  T get currentPageNum => _currentPageNum;

  ///用于在加载更多操作时，获取下一页的页码
  T getNextPageNum();

  ///分页时每一页的数据量
  final int pageSize;
}

/// 限定页码为 [int] 型
class PaginationConfigInt extends PaginationConfig<int> {
  PaginationConfigInt({
    super.startPageNum = 1,
  });

  @override
  int getNextPageNum() => _currentPageNum + 1;
}

abstract class _PaginationControllerInternal<T, W extends AbsPaginationDataWrapper<T>, N>
    extends AbsRefreshableController<T, W> implements Pagination<T> {
  _PaginationControllerInternal({
    required this.paginationConfig,
  }) : super(config: paginationConfig);

  ///配置参数
  final PaginationConfig<N> paginationConfig;

  ///加载更多操作
  @override
  @mustCallSuper
  Future<void> loadMore() async {
    //如果第一次刷新都还没执行过，则直接转接到刷新操作
    if (!refreshableStateInternal.value.isRefreshedOnce) {
      return refresh();
    }
    //没有更多数据时不允许触发加载更多操作
    if (!loadMoreStateInternal.value.hasMoreData) {
      return;
    }
    //正在加载更多数据时不允许触发加载更多操作
    if (loadMoreStateInternal.value.isLoadingMore) {
      return;
    }
    await _paginationLoadMore();
  }

  ///加载更多真实执行函数
  Future<void> _paginationLoadMore() async {
    setLoadingMore(true);
    //加载数据
    try {
      final wrapper = await loadMoreInternal();
      if (wrapper.succeed) {
        paginationConfig._currentPageNum = paginationConfig.getNextPageNum();
        if (refreshableConfig.notifyStateFirst) {
          setLoadMoreSucceed(
            succeed: true,
            hasMore: wrapper.hasMore,
          );
        }
        await onLoadMoreSucceed(wrapper);
        if (!refreshableConfig.notifyStateFirst) {
          setLoadMoreSucceed(
            succeed: true,
            hasMore: wrapper.hasMore,
          );
        }
      } else {
        if (refreshableConfig.notifyStateFirst) {
          setLoadMoreSucceed(
            succeed: false,
            hasMore: false,
          );
        }
        await onLoadMoreFailed(wrapper);
        if (!refreshableConfig.notifyStateFirst) {
          setLoadMoreSucceed(
            succeed: false,
            hasMore: false,
          );
        }
      }
    } catch (_) {
      //do something
    } finally {
      setLoadingMore(false);
    }
  }

  ///刷新成功
  @override
  @protected
  @mustCallSuper
  Future<void> onRefreshSucceed(covariant W wrapper) async {
    //当前页码赋值为初始值
    paginationConfig._currentPageNum = paginationConfig.startPageNum;
    if (refreshableConfig.notifyStateFirst) {
      setHasMoreData(wrapper.hasMore);
    }
    await super.onRefreshSucceed(wrapper);
    if (!refreshableConfig.notifyStateFirst) {
      setHasMoreData(wrapper.hasMore);
    }
  }

  ///加载更多成功
  @protected
  @mustCallSuper
  Future<void> onLoadMoreSucceed(covariant W wrapper) async {
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
  Future<void> onLoadMoreFailed(covariant W wrapper) async {
    // do something
  }

  ///加载更多操作的具体执行方法
  @protected
  Future<W> loadMoreInternal();
}
