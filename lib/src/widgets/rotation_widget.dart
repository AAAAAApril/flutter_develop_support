import 'dart:async';

import 'package:flutter/material.dart';

import 'package:april_flutter_utils/src/utils/extensions.dart';

import 'visibility_detector_widget.dart';

///循环旋转组件
///Tips：在组件不可见时，会自动暂停播放动画，并在重新显示之后自动播放
class RotationWidget extends StatefulWidget {
  const RotationWidget({
    Key? key,
    required this.detectorKey,
    required this.child,
    this.angleValues = const <double>[0, -180],
    this.durations = const <Duration>[Duration(seconds: 2)],
    this.restDuration,
  })  : assert(
          angleValues.length >= 2 &&
              durations.length >= 1 &&
              durations.length == angleValues.length - 1,
        ),
        super(key: key);

  ///被旋转的组件
  final Widget child;

  ///需要旋转的角度集（至少两个值）
  final List<double> angleValues;

  ///每次角度变化的时间集（至少一个值，且必须比 [angleValues] 少一个值）
  final List<Duration> durations;

  ///执行完成一次动画之后，停歇的时长，为 null 表示不停歇，一直重复做动画
  final Duration? restDuration;

  ///组件可见性保持 Key
  final Key detectorKey;

  @override
  State<RotationWidget> createState() => _RotationWidgetState();
}

class _RotationWidgetState extends State<RotationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  Timer? waitTimer;

  late VisibilityValueNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = VisibilityValueNotifier();
    notifier.visible.addListener(onVisibleChanged);
    init();
  }

  ///初始化
  void init() {
    controller = AnimationController(
      duration: widget.durations.total(),
      vsync: this,
    );
    animation = TweenSequence<double>(
      widget.durations.weights().forIndexedEach<TweenSequenceItem<double>>(
        (element, index) {
          return TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: widget.angleValues[index] / 360,
              end: widget.angleValues[index + 1] / 360,
            ),
            weight: element,
          );
        },
      ),
    ).animate(controller);
    animation.addStatusListener(onAnimationStatusChanged);
    controller.forward();
  }

  @override
  void didUpdateWidget(covariant RotationWidget oldWidget) {
    if (oldWidget.angleValues != widget.angleValues ||
        oldWidget.durations != widget.durations) {
      release();
      init();
    }
    super.didUpdateWidget(oldWidget);
  }

  ///释放
  void release() {
    animation.removeStatusListener(onAnimationStatusChanged);
    waitTimer?.cancel();
    controller.dispose();
  }

  @override
  void dispose() {
    release();
    notifier.dispose();
    super.dispose();
  }

  ///动画状态变化
  void onAnimationStatusChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
        break;
      case AnimationStatus.forward:
        break;
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.completed:
        //重置
        controller.reset();
        //需要等待
        if (widget.restDuration != null) {
          waitTimer?.cancel();
          waitTimer = Timer.periodic(widget.restDuration!, (timer) {
            timer.cancel();
            controller.forward();
          });
        }
        //不需要等待
        else {
          controller.forward();
        }
        break;
    }
  }

  void onVisibleChanged() {
    if (notifier.visible.value) {
      controller.forward();
    } else {
      controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetectorWidget(
      detectorKey: widget.detectorKey,
      visibilityNotifier: notifier,
      child: RotationTransition(
        turns: animation,
        child: widget.child,
      ),
    );
  }
}
