import 'package:flutter/widgets.dart';

///可自由拖拽组件
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
  _FreeDraggableWidgetState createState() => _FreeDraggableWidgetState();
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

  ///宽高边界
  late double widthBoundary, heightBoundary;

  @override
  void initState() {
    super.initState();
    widthBoundary = widget.viewportSize.width - widget.contentSize.width;
    heightBoundary = widget.viewportSize.height - widget.contentSize.height;
    offset = ValueNotifier<Offset>(
      calculateOffset(
        offset: widget.initialOffset,
        snap: widget.snap,
        padding: widget.padding,
        widthBoundary: widthBoundary,
        heightBoundary: heightBoundary,
        contentSize: widget.contentSize,
        viewportSize: widget.viewportSize,
      ),
    );
  }

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
        child: widget.child,
        feedback: widget.child,
        childWhenDragging: const SizedBox.shrink(),
        //因为没有拖拽目标，因此需要在 canceled 状态更新位置
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          this.offset.value = calculateOffset(
            padding: widget.padding,
            contentSize: widget.contentSize,
            heightBoundary: heightBoundary,
            widthBoundary: widthBoundary,
            offset: offset,
            snap: widget.snap,
            viewportSize: widget.viewportSize,
          );
        },
      ),
    );
  }
}
