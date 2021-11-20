import 'package:flutter/widgets.dart';

///监听横竖屏，并自动重新创建对应的布局
class OrientationWidget extends StatefulWidget {
  const OrientationWidget({
    Key? key,
    required this.portraitWidget,
    required this.landscapeWidget,
  }) : super(key: key);

  ///竖屏布局
  final Widget portraitWidget;

  ///横屏布局
  final Widget landscapeWidget;

  @override
  _OrientationWidgetState createState() => _OrientationWidgetState();
}

class _OrientationWidgetState extends State<OrientationWidget> {
  ///上一次的方向
  Orientation? _preOrientation;

  ///缓存的布局
  Widget? _cache;

  @override
  void didUpdateWidget(covariant OrientationWidget oldWidget) {
    if (oldWidget.portraitWidget != widget.portraitWidget ||
        oldWidget.landscapeWidget != widget.landscapeWidget) {
      _preOrientation = null;
      _cache = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_preOrientation != orientation) {
          _cache = _createWidgetByOrientation(context, orientation);
          _preOrientation = orientation;
        }
        return _cache!;
      },
    );
  }

  Widget _createWidgetByOrientation(
    BuildContext context,
    Orientation orientation,
  ) {
    return orientation == Orientation.portrait
        ? widget.portraitWidget
        : widget.landscapeWidget;
  }
}
