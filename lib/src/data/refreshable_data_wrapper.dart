///可刷新列表数据结构包装
abstract class AbsRefreshableDataWrapper<T> {
  ///数据列
  List<T> get data;

  ///业务是否成功
  bool get succeed;
}
