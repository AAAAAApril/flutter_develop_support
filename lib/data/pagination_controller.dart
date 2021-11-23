import 'package:april/data/refreshable_controller.dart';
import 'package:flutter/foundation.dart';

import 'Pagination.dart';
import 'pagination_data_wrapper.dart';

///分页列表控制器
///所有的分页列表的刷新以及加载更多逻辑都应该继承此类处理
///[T] 绑定的数据类型
///
/// Tips：写下层实现的时候，记得 with Pagination<T> 否则不会被认为是 Pagination<T> 的子类型
///
abstract class AbsPaginationController<T, W extends AbsPaginationDataWrapper<T>>
    extends AbsRefreshableController<T, W> implements Pagination<T> {
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
        _currentPageNum = startPageNum,
        super(
          data: data,
          autoRefresh: autoRefresh,
          lazyRefresh: lazyRefresh,
          autoRefreshOnEmptyList: autoRefreshOnEmptyList,
        );

  ///起始页码数
  final int startPageNum;

  ///当前页码数
  int _currentPageNum;

  int get currentPageNum => _currentPageNum;

  ///用于在加载更多操作时，获取下一页的页码
  int get nextPageNum => _currentPageNum + 1;

  ///分页时每一页的数据量
  final int pageSize;

  ///加载更多操作
  @override
  @mustCallSuper
  Future<void> loadMore() async {
    //如果第一次刷新都还没执行过，则直接转接到刷新操作
    if (!firstRefreshed) {
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
  @override
  @protected
  @mustCallSuper
  Future<void> onRefreshSucceed(covariant W wrapper) async {
    //当前页码赋值为初始值
    _currentPageNum = startPageNum;
    setHasMoreData(wrapper.hasMore);
    return super.onRefreshSucceed(wrapper);
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
    //do something
  }

  ///加载更多操作的具体执行方法
  @protected
  Future<W> loadMoreInternal();
}
