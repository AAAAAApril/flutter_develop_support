import 'package:flutter/foundation.dart';

import 'refreshable.dart';

///分页基础功能超类
mixin Pagination<T> on Refreshable<T> {
  ///是否正在加载更多
  final ValueNotifier<bool> _isLoadingMore = ValueNotifier<bool>(false);

  ValueListenable<bool> get isLoadingMore => _isLoadingMore;

  ///是否还有更多数据
  final ValueNotifier<bool> _hasMoreData = ValueNotifier<bool>(false);

  ValueListenable<bool> get hasMoreData => _hasMoreData;

  ///设置是否正在加载更多
  @protected
  void setLoadingMore(bool loading) {
    _isLoadingMore.value = loading;
  }

  ///设置是否还有更多数据
  @protected
  void setHasMoreData(bool hasMore) {
    _hasMoreData.value = hasMore;
  }

  ///加载更多操作
  Future<void> loadMore();

  ///释放资源
  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    _isLoadingMore.dispose();
    _hasMoreData.dispose();
  }
}
