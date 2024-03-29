import 'package:flutter/material.dart';

///保持状态组件
class KeepAliveWidget extends StatefulWidget {
  const KeepAliveWidget({
    Key? key,
    required this.child,
    this.wantKeepAlive = true,
  }) : super(key: key);

  final Widget child;
  final bool wantKeepAlive;

  @override
  State<KeepAliveWidget> createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}
