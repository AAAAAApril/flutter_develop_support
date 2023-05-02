part of 'refreshable.dart';

class RefreshableStateValue {
  const RefreshableStateValue({
    required this.isRefreshedOnce,
    required this.isRefreshing,
    required this.isRefreshSucceed,
  });

  const RefreshableStateValue.def()
      : isRefreshedOnce = false,
        isRefreshing = false,
        isRefreshSucceed = false;

  ///是否已经刷新过一次了（成功刷新才会计算次数）
  final bool isRefreshedOnce;

  ///是否正在刷新
  final bool isRefreshing;

  ///是否刷新成功了
  final bool isRefreshSucceed;

  RefreshableStateValue copyWith({
    bool? isRefreshedOnce,
    bool? isRefreshing,
    bool? isRefreshSucceed,
  }) =>
      RefreshableStateValue(
        isRefreshedOnce: isRefreshedOnce ?? this.isRefreshedOnce,
        isRefreshing: isRefreshing ?? this.isRefreshing,
        isRefreshSucceed: isRefreshSucceed ?? this.isRefreshSucceed,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefreshableStateValue &&
          runtimeType == other.runtimeType &&
          isRefreshedOnce == other.isRefreshedOnce &&
          isRefreshing == other.isRefreshing &&
          isRefreshSucceed == other.isRefreshSucceed;

  @override
  int get hashCode => isRefreshedOnce.hashCode ^ isRefreshing.hashCode ^ isRefreshSucceed.hashCode;
}
