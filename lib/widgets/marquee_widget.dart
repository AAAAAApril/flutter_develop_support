import 'package:flutter/widgets.dart';

import 'widget_visibility.dart';

///跑马灯效果
///由 ListView 实现
class MarqueeWidget extends StatefulWidget {
  const MarqueeWidget({
    Key? key,
    required this.detectorKey,
    required this.itemCount,
    this.scrollDirection = Axis.horizontal,
    this.padding,
    required this.limitedSize,
    required this.itemBuilder,
    this.itemSpace = 0,
    this.offsetPerTime = 100,
    this.offsetDuration = const Duration(seconds: 2),
    this.startDelayed = const Duration(seconds: 2),
  }) : super(key: key);

  final Key detectorKey;

  final int itemCount;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;
  final Widget Function(BuildContext context, int index) itemBuilder;

  ///item 之间的间隔
  final double itemSpace;

  ///横向时，表示 ListView 限定的高度；纵向时，表示限定的宽度。
  final double limitedSize;

  ///每次做滚动时，指定的偏移值
  final double offsetPerTime;

  ///每次做滚动时，执行的时长
  final Duration offsetDuration;

  ///从末尾回到开始位置之后的停顿时长
  final Duration startDelayed;

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  late ScrollController controller;

  late VisibilityValueNotifier notifier;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    notifier = VisibilityValueNotifier();
    autoScroll();
  }

  @override
  void dispose() {
    notifier.dispose();
    controller.dispose();
    super.dispose();
  }

  ///自动滚动
  void autoScroll() async {
    while (mounted) {
      if (!notifier.visible.value) {
        await Future.delayed(widget.startDelayed);
        continue;
      }
      //内部有元素了
      if (controller.hasClients) {
        //当前位置
        var current = controller.position.pixels;
        //最大位置
        var max = controller.position.maxScrollExtent;
        //已经达到最大位置了
        if (max == current) {
          //回到开始的位置
          controller.jumpTo(0.0);
          await Future.delayed(widget.startDelayed);
          continue;
        }
        //需要滚动的距离
        var offset = widget.offsetPerTime;
        //此次滚动结束位置
        var end = current + offset;
        //此次滚动需要的时间
        var duration = widget.offsetDuration;
        //结束位置超过了最大位置
        if (end > max) {
          end = max;
          //需要滚动的距离 = 最大位置 - 当前位置
          offset = max - current;
          //需要滚动的比例占约定距离的比例
          var percent = offset / widget.offsetPerTime;
          //需要滚动的时间 = 约定的时间 * 实际比例
          duration = widget.offsetDuration * percent;
        }
        //移动到目标位置
        controller.animateTo(
          end,
          duration: duration,
          curve: Curves.linear,
        );
        await Future.delayed(duration);
      }
      //内部还没有元素
      else {
        //等一秒再检测
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = VisibilityDetectorWidget(
      detectorKey: widget.detectorKey,
      visibilityNotifier: notifier,
      child: ListView.separated(
        controller: controller,
        itemCount: widget.itemCount,
        scrollDirection: widget.scrollDirection,
        padding: widget.padding,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: widget.itemBuilder,
        separatorBuilder: (_, __) => widget.scrollDirection == Axis.horizontal
            ? SizedBox(width: widget.itemSpace)
            : SizedBox(height: widget.itemSpace),
      ),
    );
    switch (widget.scrollDirection) {
      case Axis.horizontal:
        return SizedBox(
          height: widget.limitedSize,
          child: child,
        );
      case Axis.vertical:
        return SizedBox(
          width: widget.limitedSize,
          child: child,
        );
    }
  }
}
