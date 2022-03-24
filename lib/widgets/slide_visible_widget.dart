import 'package:flutter/widgets.dart';

///位移显示动画组件
class SlideVisibleWidget extends StatefulWidget {
  const SlideVisibleWidget({
    Key? key,
    required this.show,
    required this.child,
    this.animateDuration = const Duration(seconds: 1),
    this.startLocation = SlideWidgetLocation.left,
    this.animationStatusListener,
  }) : super(key: key);

  ///内部嵌套的组件
  final Widget child;

  ///是否显示动画
  final bool show;

  ///动画执行时长
  final Duration animateDuration;

  ///开始时的位置
  final SlideWidgetLocation startLocation;

  ///动画状态变更监听器
  final ValueChanged<AnimationStatus>? animationStatusListener;

  @override
  State<SlideVisibleWidget> createState() => _SlideVisibleWidgetState();
}

class _SlideVisibleWidgetState extends State<SlideVisibleWidget>
    with SingleTickerProviderStateMixin {
  ///动画控制器
  late AnimationController controller;

  ///动画
  late Animation<Offset> animation;

  ///组件是否可见
  late bool visible;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(covariant SlideVisibleWidget oldWidget) {
    //有配置变更
    if (widget.animateDuration != oldWidget.animateDuration ||
        widget.startLocation != oldWidget.startLocation) {
      release();
      init();
    }
    //没有配置变更
    else {
      if (widget.show) {
        showWidget();
      } else {
        hideWidget();
      }
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
    visible = false;
    controller = AnimationController(
      duration: widget.animateDuration,
      vsync: this,
    );
    controller.addStatusListener(onAnimationStatusChanged);
    animation = Tween<Offset>(
      begin: widget.startLocation.offset,
      end: const Offset(0, 0),
    ).animate(controller);
    if (widget.show) {
      showWidget();
    }
  }

  ///销毁
  void release() {
    controller.removeStatusListener(onAnimationStatusChanged);
    controller.dispose();
  }

  void onAnimationStatusChanged(AnimationStatus status) {
    widget.animationStatusListener?.call(status);
    if (status == AnimationStatus.dismissed) {
      visible = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  ///显示组件
  void showWidget() {
    Future.delayed(Duration.zero, () {
      if (!mounted) {
        return;
      }
      controller.forward();
      visible = true;
      setState(() {});
    });
  }

  ///隐藏组件
  void hideWidget() {
    Future.delayed(Duration.zero, () {
      if (!mounted) {
        return;
      }
      controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: SlideTransition(
        position: animation,
        child: widget.child,
      ),
    );
  }
}

///平移组件的位置
enum SlideWidgetLocation {
  //左侧
  left,
  //右侧
  right,
  //顶部
  top,
  //底部
  bottom,
  //左上角
  leftTop,
  //左下角
  leftBottom,
  //右上角
  rightTop,
  //右下角
  rightBottom,
}

extension on SlideWidgetLocation {
  Offset get offset {
    switch (this) {
      case SlideWidgetLocation.left:
        return const Offset(-1, 0);
      case SlideWidgetLocation.right:
        return const Offset(1, 0);
      case SlideWidgetLocation.top:
        return const Offset(0, -1);
      case SlideWidgetLocation.bottom:
        return const Offset(0, 1);
      case SlideWidgetLocation.leftTop:
        return const Offset(-1, -1);
      case SlideWidgetLocation.leftBottom:
        return const Offset(-1, 1);
      case SlideWidgetLocation.rightTop:
        return const Offset(1, -1);
      case SlideWidgetLocation.rightBottom:
        return const Offset(1, 1);
    }
  }
}
