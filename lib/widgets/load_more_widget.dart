import 'package:flutter/material.dart';

import 'package:april_flutter_utils/data/pagination.dart';

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
  State<LoadMoreWidget> createState() => _LoadMoreWidgetState();
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
