import 'package:flutter/widgets.dart';

///有首、尾布局的 列表
class HeaderFooterListView extends StatelessWidget {
  const HeaderFooterListView({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.header = const SizedBox.shrink(),
    this.footer = const SizedBox.shrink(),
    this.separator = const SizedBox.shrink(),
    this.needSeparatorBetweenHeader = false,
    this.needSeparatorBetweenFooter = false,
    this.direction = Axis.horizontal,
    this.physics = const BouncingScrollPhysics(),
    this.padding,
    this.shrinkWrap = false,
  }) : super(key: key);

  ///数据
  final int itemCount;

  ///item 布局构造器
  final IndexedWidgetBuilder itemBuilder;

  ///头、尾
  final Widget header, footer;

  ///分割组件（会在头和第一个item，以及最后一个item和尾之间 也添加）
  final Widget separator;

  ///是否需要在
  ///头和第一个 item
  ///最后一个 item 和尾
  ///之间添加 分割组件
  final bool needSeparatorBetweenHeader, needSeparatorBetweenFooter;

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
          if (needSeparatorBetweenHeader) {
            return separator;
          } else {
            return const SizedBox.shrink();
          }
        } else if (index == itemCount) {
          if (needSeparatorBetweenFooter) {
            return separator;
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return separator;
        }
      },
    );
  }
}
