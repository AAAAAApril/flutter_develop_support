import 'package:flutter/material.dart';

///虚线分隔符
///横线时，虚线的高度由外部给定的高度确定，反之，则由外部给定的宽度确定宽度。
class DashedSeparator extends StatelessWidget {
  const DashedSeparator({
    Key? key,
    this.size = 4,
    this.gap = 2,
    this.color,
    this.direction = Axis.vertical,
  }) : super(key: key);

  ///虚线的大小（横向的虚线时，表示虚线每个点的宽度，反之则表示虚线的高度）
  final double size;

  ///虚线每个点与点之间的间隔
  final double gap;

  ///虚线的方向
  final Axis direction;

  ///虚线的颜色，默认和分割线颜色保持一致
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double dashWidth;
        final double dashHeight;
        final int dashCount;
        //纵向的虚线
        if (direction == Axis.vertical) {
          dashWidth = constraints.constrainWidth();
          dashHeight = size;
          dashCount =
              (constraints.constrainHeight() / (dashHeight + gap)).floor();
        }
        //横向的虚线
        else {
          dashWidth = size;
          dashHeight = constraints.constrainHeight();
          dashCount =
              (constraints.constrainWidth() / (dashWidth + gap)).floor();
        }
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction,
          children: List<Widget>.generate(
            dashCount,
            (_) => SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: ColoredBox(
                color: color ?? Theme.of(context).dividerColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
