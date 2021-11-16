///分页数据结构包装
abstract class PaginationDataWrapper<T> {
  ///列表数据
  List<T> get data;

  ///业务是否成功
  bool get succeed;

  ///是否还有更多数据
  bool get hasMore;
}
