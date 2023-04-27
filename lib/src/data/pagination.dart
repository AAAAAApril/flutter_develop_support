import 'package:flutter/foundation.dart';

import 'refreshable.dart';
import 'value_notifier/cacheable_value_listenable.dart';

///分页基础功能超类
mixin Pagination<T> on Refreshable<T> {
  ///分页加载状态值
  @protected
  final CacheableValueNotifier<LoadMoreStateValue> loadMoreStateInternal = CacheableValueNotifier<LoadMoreStateValue>(
    const LoadMoreStateValue.def(),
  );

  CacheableValueListenable<LoadMoreStateValue> get loadMoreState => loadMoreStateInternal;

  ///设置是否正在加载更多
  @protected
  void setLoadingMore(bool loading) {
    loadMoreStateInternal.value = loadMoreStateInternal.value.copyWith(
      isLoadingMore: loading,
    );
  }

  ///设置是否还有更多数据
  @protected
  void setHasMoreData(bool hasMore) {
    loadMoreStateInternal.value = loadMoreStateInternal.value.copyWith(
      hasMoreData: hasMore,
    );
  }

  ///设置是否加载更多成功
  @protected
  void setLoadMoreSucceed({
    required bool succeed,
    required bool hasMore,
  }) {
    if (succeed) {
      loadMoreStateInternal.value = loadMoreStateInternal.value.copyWith(
        isLoadedOnce: true,
        loadMoreSucceed: true,
        hasMoreData: hasMore,
      );
    } else {
      loadMoreStateInternal.value = loadMoreStateInternal.value.copyWith(
        loadMoreSucceed: false,
        hasMoreData: hasMore,
      );
    }
  }

  ///加载更多操作
  Future<void> loadMore();

  ///释放资源
  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    loadMoreStateInternal.dispose();
  }
}

class LoadMoreStateValue {
  const LoadMoreStateValue({
    required this.isLoadedOnce,
    required this.isLoadingMore,
    required this.loadMoreSucceed,
    required this.hasMoreData,
  });

  const LoadMoreStateValue.def()
      : isLoadedOnce = false,
        isLoadingMore = false,
        loadMoreSucceed = false,
        hasMoreData = true;

  ///是否已经加载更多过一次了（成功加载更多一次才会计算）
  final bool isLoadedOnce;

  ///是否正在加载更多
  final bool isLoadingMore;

  ///是否加载更多成功了
  final bool loadMoreSucceed;

  ///是否还有更多数据
  final bool hasMoreData;

  LoadMoreStateValue copyWith({
    bool? isLoadedOnce,
    bool? isLoadingMore,
    bool? loadMoreSucceed,
    bool? hasMoreData,
  }) =>
      LoadMoreStateValue(
        isLoadedOnce: isLoadedOnce ?? this.isLoadedOnce,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        loadMoreSucceed: loadMoreSucceed ?? this.loadMoreSucceed,
        hasMoreData: hasMoreData ?? this.hasMoreData,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadMoreStateValue &&
          runtimeType == other.runtimeType &&
          isLoadedOnce == other.isLoadedOnce &&
          isLoadingMore == other.isLoadingMore &&
          loadMoreSucceed == other.loadMoreSucceed &&
          hasMoreData == other.hasMoreData;

  @override
  int get hashCode => isLoadedOnce.hashCode ^ isLoadingMore.hashCode ^ loadMoreSucceed.hashCode ^ hasMoreData.hashCode;
}
