import 'package:april/data/pagination.dart';
import 'package:flutter/material.dart';

import 'select_listenable_builder.dart';

typedef ItemBuilder<T> = Widget Function(
  BuildContext context,
  List<T> value,
  int index,
);

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

///自带刷新以及加载更多功能的 ListView
class PaginationListView<T> extends StatelessWidget {
  const PaginationListView({
    Key? key,
    required this.controller,
    required this.itemBuilder,
    this.padding,
    this.shrinkWrap = false,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.scrollDirection = Axis.vertical,
    this.scrollController,
    this.placeholderScrollController,
    this.needRefresh = true,
    this.header = const SizedBox.shrink(),
    this.footer,
    this.separator = const SizedBox.shrink(),
    this.needSeparatorBetweenHeader = false,
    this.needSeparatorBetweenFooter = false,
    this.placeholderWidget,
  }) : super(key: key);

  final Pagination<T> controller;
  final ItemBuilder<T> itemBuilder;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final ScrollController? scrollController;
  final ScrollController? placeholderScrollController;
  final bool needRefresh;

  ///头
  final Widget header;

  ///尾 即使这个值为 null，也会自动添加一个 [LoadMoreWidget]
  final Widget? footer;

  ///分割组件（会在头和第一个item，以及最后一个item和尾之间 也添加）
  final Widget separator;

  ///是否需要在
  ///头和第一个 item
  ///最后一个 item 和尾
  ///之间添加 分割组件
  final bool needSeparatorBetweenHeader, needSeparatorBetweenFooter;

  ///空列表时的占位布局
  final Widget? placeholderWidget;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SelectListenableBuilder<List<T>, bool>(
        valueListenable: controller.data,
        selector: (value) => value.isEmpty && placeholderWidget != null,
        builder: (context, value, child) {
          Widget result = value
              ? ListView(
                  controller: placeholderScrollController,
                  physics: physics,
                  padding: padding,
                  scrollDirection: scrollDirection,
                  shrinkWrap: shrinkWrap,
                  children: [
                    SizedBox(
                      height: constraints.maxHeight,
                      child: placeholderWidget!,
                    ),
                  ],
                )
              : child!;
          if (needRefresh) {
            result = RefreshIndicator(
              onRefresh: controller.refresh,
              child: result,
            );
          }
          return result;
        },
        child: ValueListenableBuilder<List<T>>(
          valueListenable: controller.data,
          builder: (context, value, child) => ListView.separated(
            itemCount: 1 +
                value.length +
                (controller.hasMoreData.value == true ? 1 : 0),
            padding: padding,
            shrinkWrap: shrinkWrap,
            physics: physics,
            scrollDirection: scrollDirection,
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index == 0) {
                return header;
              } else if (index == value.length + 1) {
                return footer ?? LoadMoreWidget(controller: controller);
              }
              return itemBuilder.call(context, value, index - 1);
            },
            separatorBuilder: (context, index) {
              if (index == 0) {
                if (needSeparatorBetweenHeader) {
                  return separator;
                } else {
                  return const SizedBox.shrink();
                }
              } else if (index == value.length) {
                if (needSeparatorBetweenFooter) {
                  return separator;
                } else {
                  return const SizedBox.shrink();
                }
              } else {
                return separator;
              }
            },
          ),
        ),
      ),
    );
  }
}

///自带刷新以及加载更多功能的 GridView
class PaginationGridView<T> extends StatelessWidget {
  const PaginationGridView({
    Key? key,
    required this.controller,
    required this.gridDelegate,
    required this.itemBuilder,
    this.padding,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.scrollController,
    this.placeholderScrollController,
    this.needRefresh = true,
    this.placeholderWidget,
  }) : super(key: key);

  final Pagination<T> controller;
  final SliverGridDelegate gridDelegate;
  final ItemBuilder<T> itemBuilder;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final ScrollController? scrollController;
  final ScrollController? placeholderScrollController;
  final bool needRefresh;

  ///空列表时的占位布局
  final Widget? placeholderWidget;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SelectListenableBuilder<List<T>, bool>(
        valueListenable: controller.data,
        selector: (value) => value.isEmpty && placeholderWidget != null,
        builder: (context, value, child) {
          Widget result = value
              ? ListView(
                  controller: placeholderScrollController,
                  physics: physics,
                  padding: padding,
                  scrollDirection: scrollDirection,
                  shrinkWrap: shrinkWrap,
                  children: [
                    SizedBox(
                      height: constraints.maxHeight,
                      child: placeholderWidget!,
                    ),
                  ],
                )
              : child!;
          if (needRefresh) {
            result = RefreshIndicator(
              onRefresh: controller.refresh,
              child: result,
            );
          }
          return result;
        },
        child: ValueListenableBuilder<List<T>>(
          valueListenable: controller.data,
          builder: (context, value, child) => GridView.builder(
            itemCount:
                value.length + (controller.hasMoreData.value == true ? 1 : 0),
            padding: padding,
            shrinkWrap: shrinkWrap,
            physics: physics,
            scrollDirection: scrollDirection,
            controller: scrollController,
            gridDelegate: gridDelegate,
            itemBuilder: (context, index) => index == value.length
                ? LoadMoreWidget(controller: controller)
                : itemBuilder.call(context, value, index),
          ),
        ),
      ),
    );
  }
}

///自带刷新以及加载更多功能的 PageView
class PaginationPageView<T> extends StatelessWidget {
  const PaginationPageView({
    Key? key,
    required this.controller,
    required this.itemBuilder,
    this.physics,
    this.scrollDirection = Axis.vertical,
    this.pageController,
    this.needRefresh = true,
    this.onPageChanged,
    this.footer,
  }) : super(key: key);

  final Pagination<T> controller;
  final ItemBuilder<T> itemBuilder;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final PageController? pageController;
  final bool needRefresh;
  final ValueChanged<int>? onPageChanged;

  ///尾 即使这个值为 null，也会自动添加一个 [LoadMoreWidget]
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    Widget child = ValueListenableBuilder<List<T>>(
      valueListenable: controller.data,
      builder: (context, value, child) => PageView.builder(
        controller: pageController,
        physics: physics,
        itemCount:
            value.length + (controller.hasMoreData.value == true ? 1 : 0),
        onPageChanged: onPageChanged,
        scrollDirection: scrollDirection,
        allowImplicitScrolling: true,
        itemBuilder: (context, index) => index == value.length
            ? footer ??
                LoadMoreWidget(
                  controller: controller,
                  child: const SizedBox.expand(),
                )
            : itemBuilder.call(context, value, index),
      ),
    );
    if (needRefresh) {
      child = RefreshIndicator(
        onRefresh: controller.refresh,
        child: child,
      );
    }
    return child;
  }
}
