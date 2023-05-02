part of '../pagination.dart';

/// 没有数据包装类的刷新控制器实现
/// [N] 分页参数的
/// Tips: 始终认定还有更多数据
abstract class SimplePaginationController<T, N> extends SimpleRefreshableController<T> with Pagination<T> {
  SimplePaginationController({
    required this.paginationConfig,
  }) : super(config: paginationConfig);

  ///配置参数
  final PaginationConfig<N> paginationConfig;

  ///加载更多操作的具体执行方法
  @protected
  Future<List<T>> loadMoreInternal();

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
      //只要没有抛异常，就认为加载更多成功
      final data = await loadMoreInternal();
      paginationConfig._currentPageNum = paginationConfig.getNextPageNum();
      if (refreshableConfig.notifyStateFirst) {
        setLoadMoreSucceed(succeed: true);
      }
      await onLoadMoreSucceed(data);
      if (!refreshableConfig.notifyStateFirst) {
        setLoadMoreSucceed(succeed: true);
      }
    } catch (_) {
      if (refreshableConfig.notifyStateFirst) {
        setLoadMoreSucceed(succeed: false);
      }
      await onLoadMoreFailed();
      if (!refreshableConfig.notifyStateFirst) {
        setLoadMoreSucceed(succeed: false);
      }
    } finally {
      setLoadingMore(false);
    }
  }

  @override
  void setLoadMoreSucceed({required bool succeed, bool hasMore = true}) {
    super.setLoadMoreSucceed(succeed: succeed, hasMore: hasMore);
  }

  ///刷新成功
  @override
  @protected
  @mustCallSuper
  Future<void> onRefreshSucceed(List<T> data) async {
    //当前页码赋值为初始值
    paginationConfig._currentPageNum = paginationConfig.startPageNum;
    if (refreshableConfig.notifyStateFirst) {
      setHasMoreData(true);
    }
    await super.onRefreshSucceed(data);
    if (!refreshableConfig.notifyStateFirst) {
      setHasMoreData(true);
    }
  }

  ///加载更多成功
  @protected
  @mustCallSuper
  Future<void> onLoadMoreSucceed(List<T> data) async {
    if (data.isEmpty) {
      return;
    }
    setData(
      await onInterceptAllData(
        List.of(dataValue)
          ..addAll(
            await onInterceptNewData(data),
          ),
      ),
    );
  }

  ///加载更多失败
  @protected
  @mustCallSuper
  Future<void> onLoadMoreFailed() async {
    // do something
  }
}

///限定页码数为 [int] 型的简单分页控制器
abstract class SimpleIntPaginationController<T> extends SimplePaginationController<T, int> {
  SimpleIntPaginationController({
    PaginationConfig<int>? paginationConfig,
  }) : super(paginationConfig: paginationConfig ?? IntPaginationConfig());

  ///请求接口
  @protected
  Future<List<T>> requestInternal({required int pageNum, required int pageSize});

  @override
  Future<List<T>> refreshInternal() => requestInternal(
        pageNum: paginationConfig.startPageNum,
        pageSize: paginationConfig.pageSize,
      );

  @override
  Future<List<T>> loadMoreInternal() => requestInternal(
        pageNum: paginationConfig.getNextPageNum(),
        pageSize: paginationConfig.pageSize,
      );
}

///一个可以直接初始化的实现类
class PaginationController<T> extends SimpleIntPaginationController<T> {
  PaginationController({
    required Future<List<T>> Function(int pageNum, int pageSize) request,
    super.paginationConfig,
  }) : _request = request;

  final Future<List<T>> Function(int pageNum, int pageSize) _request;

  @override
  Future<List<T>> requestInternal({required int pageNum, required int pageSize}) => _request.call(pageNum, pageSize);
}
