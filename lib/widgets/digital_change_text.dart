import 'package:flutter/material.dart';

///设置了不同数字的时候，会在新值与旧值之间做一个增长或者减少动画
class DigitalChangeText extends StatefulWidget {
  const DigitalChangeText(
    this.number, {
    Key? key,
    this.style,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  final int number;
  final TextStyle? style;
  final Duration duration;

  @override
  State<DigitalChangeText> createState() => _DigitalChangeTextState();
}

class _DigitalChangeTextState extends State<DigitalChangeText>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<int> animation;

  ///做动画的开始值
  late int startValue;

  @override
  void initState() {
    super.initState();
    startValue = 0;
    initAnimation();
  }

  @override
  void didUpdateWidget(covariant DigitalChangeText oldWidget) {
    if (widget.number != oldWidget.number) {
      startValue = oldWidget.number;
      releaseAnimation();
      initAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    releaseAnimation();
    super.dispose();
  }

  ///初始化动画
  void initAnimation() {
    ///目标值与起始值的差值
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    animation = IntTween(
      begin: startValue,
      end: widget.number,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linearToEaseOut,
      ),
    );
    //起始值和结束值不同时，才执行动画
    if (startValue != widget.number) {
      controller.forward();
    }
  }

  ///释放动画
  void releaseAnimation() {
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Text(
        animation.value.toString(),
        style: widget.style,
      ),
    );
  }
}
