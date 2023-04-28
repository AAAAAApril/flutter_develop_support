import 'package:flutter/widgets.dart';

///可自由拖拽组件
///Tips：[FreeDraggableWidget] 的父组件必须是 [Stack]
class FreeDraggableWidget extends StatefulWidget {
  const FreeDraggableWidget({
    Key? key,
    required this.child,
    required this.initialOffset,
    required this.contentSize,
    required this.viewportSize,
    this.snap = false,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  ///初始偏移量
  final Offset initialOffset;

  ///内容
  final Widget child;

  ///内容大小
  final Size contentSize;

  ///容器大小
  final Size viewportSize;

  ///在拖动结束之后自动贴靠左右
  final bool snap;

  ///组件与容器边框的距离
  final EdgeInsets padding;

  @override
  State<FreeDraggableWidget> createState() => _FreeDraggableWidgetState();
}

class _FreeDraggableWidgetState extends State<FreeDraggableWidget> {
  static Offset calculateOffset({
    required Offset offset,
    required bool snap,
    required EdgeInsets padding,
    required double widthBoundary,
    required double heightBoundary,
    required Size contentSize,
    required Size viewportSize,
  }) {
    offset = Offset(
      offset.dx,
      offset.dy < padding.top
          ? padding.top
          : offset.dy > (heightBoundary - padding.bottom)
              ? (heightBoundary - padding.bottom)
              : offset.dy,
    );
    if (snap) {
      offset = Offset(
        ((offset.dx + (contentSize.width / 2)) < ((viewportSize.width) / 2))
            ? padding.left
            : widthBoundary - padding.right,
        offset.dy,
      );
    } else {
      offset = Offset(
        offset.dx < padding.left
            ? padding.left
            : offset.dx > (widthBoundary - padding.right)
                ? (widthBoundary - padding.right)
                : offset.dx,
        offset.dy,
      );
    }
    return offset;
  }

  late ValueNotifier<Offset> offset;
  late Offset currentOffset;

  ///宽高边界
  late double widthBoundary, heightBoundary;

  @override
  void initState() {
    super.initState();
    widthBoundary = widget.viewportSize.width - widget.contentSize.width;
    heightBoundary = widget.viewportSize.height - widget.contentSize.height;
    currentOffset = widget.initialOffset;
    offset = ValueNotifier<Offset>(offsetValue);
  }

  @override
  void didUpdateWidget(covariant FreeDraggableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Offset get offsetValue => calculateOffset(
        offset: currentOffset,
        snap: widget.snap,
        padding: widget.padding,
        widthBoundary: widthBoundary,
        heightBoundary: heightBoundary,
        contentSize: widget.contentSize,
        viewportSize: widget.viewportSize,
      );

  @override
  void dispose() {
    offset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: offset,
      builder: (context, value, child) => Positioned(
        left: value.dx,
        top: value.dy,
        child: child!,
      ),
      child: Draggable(
        feedback: widget.child,
        childWhenDragging: const SizedBox.shrink(),
        //因为没有拖拽目标，因此需要在 canceled 状态更新位置
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          currentOffset = offset;
          this.offset.value = offsetValue;
        },
        child: widget.child,
      ),
    );
  }
}

class FreeDraggableWrapper extends StatelessWidget {
  const FreeDraggableWrapper({
    Key? key,
    this.freeDraggableWidgetKey,
    required this.main,
    required this.draggableWidget,
    this.initialOffset,
    required this.contentSize,
    this.snap = false,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final Key? freeDraggableWidgetKey;

  ///主界面
  final Widget main;

  ///可以被拖动的组件
  final Widget draggableWidget;

  ///初始偏移量
  final Offset Function(
    BuildContext context,
    BoxConstraints constraints,
  )? initialOffset;

  ///内容大小
  final Size contentSize;

  ///在拖动结束之后自动贴靠左右
  final bool snap;

  ///组件与容器边框的距离
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(children: [
        main,
        FreeDraggableWidget(
          key: freeDraggableWidgetKey,
          initialOffset:
              initialOffset?.call(context, constraints) ?? const Offset(0, 0),
          contentSize: contentSize,
          padding: padding,
          snap: snap,
          viewportSize: Size(constraints.maxWidth, constraints.maxHeight),
          child: draggableWidget,
        ),
      ]),
    );
  }
}
