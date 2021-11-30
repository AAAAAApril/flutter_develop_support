import 'package:april/data/pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'transform_listenable_builder.dart';

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
    this.physics,
    this.scrollDirection = Axis.vertical,
    this.scrollController,
    this.placeholderScrollController,
    this.needRefresh = true,
    this.header = const SizedBox.shrink(),
    this.footer,
    this.headerSeparator = const SizedBox.shrink(),
    this.footerSeparator = const SizedBox.shrink(),
    this.separatorBuilder,
    this.placeholderWidget,
  }) : super(key: key);

  final Pagination<T> controller;
  final Widget Function(
    BuildContext context,
    List<T> valueList,
    int index,
  ) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final ScrollController? scrollController;
  final ScrollController? placeholderScrollController;
  final bool needRefresh;

  ///头
  final Widget header;

  ///头部与真实 item 之间的分割布局
  final Widget headerSeparator;

  ///尾 即使这个值为 null，也会自动添加一个 [LoadMoreWidget]
  final Widget? footer;

  ///尾部与真实 item 之间的分割布局
  final Widget footerSeparator;

  ///分割组件（会在头和第一个item，以及最后一个item和尾之间 也添加）
  final IndexedWidgetBuilder? separatorBuilder;

  ///空列表时的占位布局
  final Widget? placeholderWidget;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          TransformListenableBuilder<List<T>, bool>(
        listenable: controller.data,
        transformer: (value) => value.isEmpty && placeholderWidget != null,
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
                return headerSeparator;
              } else if (index == value.length) {
                return footerSeparator;
              } else {
                return separatorBuilder?.call(context, index - 1) ??
                    const SizedBox.shrink();
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
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.scrollController,
    this.placeholderScrollController,
    this.needRefresh = true,
    this.placeholderWidget,
  }) : super(key: key);

  final Pagination<T> controller;
  final SliverGridDelegate gridDelegate;

  final Widget Function(
    BuildContext context,
    List<T> valueList,
    int index,
  ) itemBuilder;

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
      builder: (context, constraints) =>
          TransformListenableBuilder<List<T>, bool>(
        listenable: controller.data,
        transformer: (value) => value.isEmpty && placeholderWidget != null,
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

  final Widget Function(
    BuildContext context,
    List<T> valueList,
    int index,
  ) itemBuilder;

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

///自带刷新和加载更多功能的 瀑布流 式布局
class PaginationStaggeredGridView<T> extends StatelessWidget {
  const PaginationStaggeredGridView({
    Key? key,
    required this.controller,
    required this.itemBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.scrollController,
    this.placeholderScrollController,
    this.needRefresh = true,
    this.placeholderWidget,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.addAutomaticKeepAlives = true,
  }) : super(key: key);

  final Pagination<T> controller;

  final Widget Function(
    BuildContext context,
    List<T> valueList,
    int index,
  ) itemBuilder;

  final int crossAxisCount;
  final double mainAxisSpacing, crossAxisSpacing;
  final bool addAutomaticKeepAlives;

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
      builder: (context, constraints) =>
          TransformListenableBuilder<List<T>, bool>(
        listenable: controller.data,
        transformer: (value) => value.isEmpty && placeholderWidget != null,
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
          builder: (context, value, child) => StaggeredGridView.countBuilder(
            controller: scrollController,
            itemCount: value.length,
            crossAxisCount: crossAxisCount,
            padding: padding,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            shrinkWrap: shrinkWrap,
            physics: physics,
            scrollDirection: scrollDirection,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            itemBuilder: (context, index) =>
                itemBuilder.call(context, value, index),
            staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
          ),
        ),
      ),
    );
  }
}
