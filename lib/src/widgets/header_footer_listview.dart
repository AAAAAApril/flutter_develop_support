import 'package:flutter/widgets.dart';

///有首、尾布局的 列表
class HeaderFooterListView extends StatelessWidget {
  const HeaderFooterListView({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.header = const SizedBox.shrink(),
    this.headerSeparator = const SizedBox.shrink(),
    this.footer = const SizedBox.shrink(),
    this.footerSeparator = const SizedBox.shrink(),
    this.separatorBuilder,
    this.direction = Axis.horizontal,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
  }) : super(key: key);

  ///数据
  final int itemCount;

  ///item 布局构造器
  final IndexedWidgetBuilder itemBuilder;

  ///头、尾
  final Widget header, footer;

  ///头、尾 和正常 item 之间的分割 组件
  final Widget headerSeparator, footerSeparator;

  ///分割组件（会在头和第一个item，以及最后一个item和尾之间 也添加）
  final IndexedWidgetBuilder? separatorBuilder;

  ///滚动方向
  final Axis direction;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: direction,
      itemCount: itemCount + 2,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        if (index == 0) {
          return header;
        } else if (index == itemCount + 1) {
          return footer;
        } else {
          return itemBuilder.call(context, index - 1);
        }
      },
      separatorBuilder: (context, index) {
        if (index == 0) {
          return headerSeparator;
        } else if (index == itemCount) {
          return footerSeparator;
        } else {
          return separatorBuilder?.call(context, index - 1) ??
              const SizedBox.shrink();
        }
      },
    );
  }
}
