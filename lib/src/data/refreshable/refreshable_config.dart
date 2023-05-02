part of 'refreshable.dart';

///刷新功能的一些配置参数
class RefreshableConfig {
  const RefreshableConfig({
    this.notifyStateFirst = true,
    this.autoRefresh = true,
    this.lazyRefresh = true,
    this.autoRefreshOnEmptyList = true,
  });

  ///是否优先更新状态，而不是数据
  final bool notifyStateFirst;

  ///是否自动触发一次刷新
  final bool autoRefresh;

  ///是否懒刷新，如果是，则在第一次获取数据监听器的时候刷新
  ///否则，则在构造函数内刷新。
  ///当 [autoRefresh] 为 true 时生效
  final bool lazyRefresh;

  ///获取数据监听器其时，发现数据量为空，是否触发刷新
  final bool autoRefreshOnEmptyList;
}
