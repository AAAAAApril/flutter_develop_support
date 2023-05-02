part of 'pagination.dart';

///分页功能的一些配置参数
/// [T] 页码数的数据类型
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

///一个可以直接初始化的实现类
class SimplePaginationConfig<T> extends PaginationConfig<T> {
  SimplePaginationConfig({
    required super.startPageNum,
    required T Function(T currentPageNum) getNextPageNum,
  }) : _getNextPageNum = getNextPageNum;

  final T Function(T currentPageNum) _getNextPageNum;

  @override
  T getNextPageNum() => _getNextPageNum.call(_currentPageNum);
}

/// 限定页码为 [int] 型
class IntPaginationConfig extends PaginationConfig<int> {
  IntPaginationConfig({
    super.startPageNum = 1,
    super.pageSize,
    super.autoRefresh,
    super.autoRefreshOnEmptyList,
    super.lazyRefresh,
    super.notifyStateFirst,
  });

  @override
  int getNextPageNum() => _currentPageNum + 1;
}
