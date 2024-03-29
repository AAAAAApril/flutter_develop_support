part of 'pagination.dart';

///分页数据结构包装
abstract class AbsPaginationDataWrapper<T> extends AbsRefreshableDataWrapper<T> {
  ///是否还有更多数据
  bool get hasMore;
}
