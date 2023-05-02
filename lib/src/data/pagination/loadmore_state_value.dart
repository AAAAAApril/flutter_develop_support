part of 'pagination.dart';

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
