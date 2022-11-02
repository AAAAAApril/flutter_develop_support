import 'package:flutter/foundation.dart';

import 'pagination.dart';
import 'pagination_data_wrapper.dart';
import 'refreshable_controller.dart';

///分页列表控制器
///所有的分页列表的刷新以及加载更多逻辑都应该继承此类处理
///[T] 绑定的数据类型
abstract class AbsPaginationController<T, W extends AbsPaginationDataWrapper<T>>
    extends _PaginationControllerInternal<T, W> with Pagination<T> {
  AbsPaginationController({
    //默认的数据
    List<T>? data,
    PaginationConfig? config,
  }) : super(
          data: data,
          paginationConfig: config ?? PaginationConfig(),
        );
}

abstract class _PaginationControllerInternal<T,
        W extends AbsPaginationDataWrapper<T>>
    extends AbsRefreshableController<T, W> implements Pagination<T> {
  _PaginationControllerInternal({
    required List<T>? data,
    required this.paginationConfig,
  }) : super(data: data, config: paginationConfig);

  ///配置参数
  final PaginationConfig paginationConfig;

  ///数据加载更多结果监听器（将会在数据更新之前回调）
  /// [bool] 是否加载更多成功
  final List<ValueChanged<bool>> _onLoadMoreResultListeners =
      <ValueChanged<bool>>[];

  ///添加加载更多结果监听器
  void addLoadMoreResultListener(ValueChanged<bool> listener) {
    _onLoadMoreResultListeners.add(listener);
  }

  ///移除加载更多结果监听器
  void removeLoadMoreResultListener(ValueChanged<bool> listener) {
    _onLoadMoreResultListeners.remove(listener);
  }

  ///加载更多操作
  @override
  @mustCallSuper
  Future<void> loadMore() async {
    //如果第一次刷新都还没执行过，则直接转接到刷新操作
    if (!paginationConfig.firstRefreshed) {
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
    try {
      final wrapper = await loadMoreInternal();
      if (wrapper.succeed) {
        paginationConfig._currentPageNum = paginationConfig.nextPageNum;
        setHasMoreData(wrapper.hasMore);
        //通知监听器，加载更多成功
        for (var element in _onLoadMoreResultListeners) {
          element.call(true);
        }
        await onLoadMoreSucceed(wrapper);
      } else {
        //通知监听器，加载更多失败
        for (var element in _onLoadMoreResultListeners) {
          element.call(false);
        }
        await onLoadMoreFailed(wrapper);
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
    // do something
  }

  ///加载更多操作的具体执行方法
  @protected
  Future<W> loadMoreInternal();
}

///分页功能的一些配置参数
class PaginationConfig extends RefreshableConfig {
  PaginationConfig({
    this.startPageNum = 1,
    this.pageSize = 20,
    bool autoRefresh = true,
    bool lazyRefresh = true,
    bool autoRefreshOnEmptyList = true,
  })  : assert(pageSize > 0),
        _currentPageNum = startPageNum,
        super(
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
}
