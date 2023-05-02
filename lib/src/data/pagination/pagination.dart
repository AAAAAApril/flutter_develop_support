import 'package:april_flutter_utils/src/data/refreshable/refreshable.dart';
import 'package:april_flutter_utils/src/data/value_notifier/cacheable_value_listenable.dart';

import 'package:flutter/foundation.dart';

part 'loadmore_state_value.dart';

part 'pagination_config.dart';

part 'pagination_controller.dart';

part 'pagination_data_wrapper.dart';

part 'simple/simple_pagination_controller.dart';

///分页基础功能超类
mixin Pagination<T> on Refreshable<T> {
  ///分页加载状态值
  @protected
  final CacheableValueNotifier<LoadMoreStateValue> loadMoreStateInternal = CacheableValueNotifier<LoadMoreStateValue>(
    const LoadMoreStateValue.def(),
    maxCacheCount: 5,
  );

  CacheableValueListenable<LoadMoreStateValue> get loadMoreState => loadMoreStateInternal;

  ///重置加载过一次状态
  @protected
  void resetLoadedOnce() {
    loadMoreStateInternal.value = loadMoreStateInternal.value.copyWith(
      isLoadedOnce: false,
    );
  }

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
