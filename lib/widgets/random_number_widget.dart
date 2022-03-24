import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';

class RandomNumberWidget extends StatefulWidget {
  const RandomNumberWidget({
    Key? key,
    required this.number,
    required this.builder,
    this.child,
    this.duration = const Duration(milliseconds: 100),
    this.ticks = 3,
  })  : assert(number == null || number < 0 || (number >= 0 && number < 10)),
        super(key: key);

  ///目标数字
  ///null：取消随机动画
  ///负数：开始随机动画
  ///[0,9]：目标数字
  final int? number;

  ///获取随机数的定时器的执行间隔
  final Duration duration;

  ///当 [number] 有了目标数字之后，定时器还需要执行多少次，才停留在目标数字上
  final int ticks;

  final Widget Function(
    BuildContext context,
    int number,
    Widget? child,
  ) builder;
  final Widget? child;

  @override
  State<RandomNumberWidget> createState() => _RandomNumberWidgetState();
}

class _RandomNumberWidgetState extends State<RandomNumberWidget> {
  final Random random = Random.secure();

  ///执行随机变动的定时器
  Timer? timer;

  int value = 0;

  @override
  void didUpdateWidget(covariant RandomNumberWidget oldWidget) {
    ///需要取消定时器
    final int? newNumber = widget.number;
    if (newNumber == null) {
      timer?.cancel();
    }

    ///需要开始随机
    else if (newNumber < 0) {
      randomTimerTick();
    }

    ///需要滚动到目标数字
    else if (newNumber >= 0 && newNumber <= 9) {
      targetTimerTick();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  ///开始随机显示
  void randomTimerTick() {
    timer?.cancel();
    timer = Timer.periodic(widget.duration, (timer) {
      value = random.nextInt(10);
      setState(() {});
    });
  }

  ///开始目标显示
  void targetTimerTick() {
    timer?.cancel();
    timer = Timer.periodic(widget.duration, (timer) {
      final int? target = widget.number;
      if (timer.tick > widget.ticks && target != null) {
        timer.cancel();
        value = target;
      } else {
        value = random.nextInt(10);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, value, widget.child);
  }
}
