import 'package:april/widgets/widget_visibility.dart';
import 'package:flutter/material.dart';

import 'package:april/utils/extensions.dart';

///可以周期性执行缩放动画的组件
class PeriodicScaleAnimationWidget extends StatefulWidget {
  const PeriodicScaleAnimationWidget({
    Key? key,
    required this.child,
    required this.detectorKey,
    this.duration = const Duration(milliseconds: 1500),
    this.scales = const <double>[1.0, 1.2, 1.0, 0.8],
  })  : assert(scales.length >= 2),
        super(key: key);

  ///需要被缩放的组件
  final Widget child;

  ///缩放比例（起始到结束的值集）
  final List<double> scales;

  ///动画执行时长
  final Duration duration;

  ///组件可见性保持 Key
  final Key detectorKey;

  @override
  State<PeriodicScaleAnimationWidget> createState() =>
      _ScaleAnimateWidgetState();
}

class _ScaleAnimateWidgetState extends State<PeriodicScaleAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(covariant PeriodicScaleAnimationWidget oldWidget) {
    if (widget.scales != oldWidget.scales) {
      release();
      init();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    release();
    super.dispose();
  }

  ///初始化
  void init() {
    controller = AnimationController(
      duration: widget.duration,
      reverseDuration: widget.duration,
      vsync: this,
    );
    animation = TweenSequence<double>(
      widget.scales.forIndexedEach<TweenSequenceItem<double>>(
        (element, index) {
          final double next;
          //当前是最后一个
          if (index == widget.scales.length - 1) {
            next = widget.scales.first;
          }
          //当前不是最后一个
          else {
            next = widget.scales[index + 1];
          }
          return TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: widget.scales[index],
              end: next,
            ),
            weight: element,
          );
        },
      ),
    ).animate(controller);
    controller.repeat();
  }

  ///释放资源
  void release() {
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetectorWidget(
      detectorKey: widget.detectorKey,
      onVisibleChanged: (visible) {
        if (visible) {
          controller.forward();
        } else {
          controller.stop();
        }
      },
      child: ScaleTransition(
        scale: animation,
        child: widget.child,
      ),
    );
  }
}
