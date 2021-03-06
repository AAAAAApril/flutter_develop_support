import 'package:april/data/pagination.dart';
import 'package:flutter/material.dart';

///自动触发加载更多操作的占位布局
class LoadMoreWidget extends StatefulWidget {
  const LoadMoreWidget({
    Key? key,
    this.controller,
    this.sliver = false,
    this.child = const SizedBox.shrink(),
  }) : super(key: key);

  final Pagination? controller;
  final bool sliver;
  final Widget child;

  @override
  _LoadMoreWidgetState createState() => _LoadMoreWidgetState();
}

class _LoadMoreWidgetState extends State<LoadMoreWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller?.loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return widget.sliver
        ? SliverToBoxAdapter(child: widget.child)
        : widget.child;
  }
}
