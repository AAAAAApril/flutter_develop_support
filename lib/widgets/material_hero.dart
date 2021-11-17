import 'package:flutter/material.dart';

///用 [Material] 包裹 [Hero] child，避免样式丢失
class MaterialHero extends StatelessWidget {
  const MaterialHero(
    this.tag, {
    Key? key,
    required this.child,
    this.createRectTween,
    this.flightShuttleBuilder,
    this.placeholderBuilder,
    this.transitionOnUserGestures = true,
  }) : super(key: key);

  final Object tag;
  final Widget child;

  final CreateRectTween? createRectTween;
  final HeroFlightShuttleBuilder? flightShuttleBuilder;
  final HeroPlaceholderBuilder? placeholderBuilder;
  final bool transitionOnUserGestures;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      createRectTween: createRectTween,
      flightShuttleBuilder: flightShuttleBuilder,
      placeholderBuilder: placeholderBuilder,
      transitionOnUserGestures: transitionOnUserGestures,
      //如果这里不用 Material 包裹，在遇到内部显示文字时，可能会出现在动画过程中样式丢失的情况
      child: Material(child: child, color: Colors.transparent),
    );
  }
}
