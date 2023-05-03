import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

///同时监听两个数据观察者
class ValueListenableBuilder2<A, B> extends StatefulWidget {
  const ValueListenableBuilder2({
    super.key,
    required this.listenableA,
    required this.listenableB,
    required this.builder,
    this.child,
  });

  final ValueListenable<A> listenableA;
  final ValueListenable<B> listenableB;
  final Widget Function(BuildContext context, A valueA, B valueB, Widget? child) builder;
  final Widget? child;

  @override
  State<ValueListenableBuilder2<A, B>> createState() => _ValueListenableBuilder2State<A, B>();
}

class _ValueListenableBuilder2State<A, B> extends State<ValueListenableBuilder2<A, B>> {
  late A valueA;
  late B valueB;

  @override
  void initState() {
    super.initState();
    valueA = widget.listenableA.value;
    valueB = widget.listenableB.value;
    widget.listenableA.addListener(_onValueChanged);
    widget.listenableB.addListener(_onValueChanged);
  }

  @override
  void didUpdateWidget(covariant ValueListenableBuilder2<A, B> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listenableA != widget.listenableA) {
      oldWidget.listenableA.removeListener(_onValueChanged);
      valueA = widget.listenableA.value;
      widget.listenableA.addListener(_onValueChanged);
    }
    if (oldWidget.listenableB != widget.listenableB) {
      oldWidget.listenableB.removeListener(_onValueChanged);
      valueB = widget.listenableB.value;
      widget.listenableB.addListener(_onValueChanged);
    }
  }

  @override
  void dispose() {
    widget.listenableA.removeListener(_onValueChanged);
    widget.listenableB.removeListener(_onValueChanged);
    super.dispose();
  }

  void _onValueChanged() {
    final A oldA = valueA;
    final B oldB = valueB;
    valueA = widget.listenableA.value;
    valueB = widget.listenableB.value;
    if (oldA == valueA && oldB == valueB) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, valueA, valueB, widget.child);
  }
}

///同时监听三个数据观察者
class ValueListenableBuilder3<A, B, C> extends StatefulWidget {
  const ValueListenableBuilder3({
    super.key,
    required this.listenableA,
    required this.listenableB,
    required this.listenableC,
    required this.builder,
    this.child,
  });

  final ValueListenable<A> listenableA;
  final ValueListenable<B> listenableB;
  final ValueListenable<C> listenableC;
  final Widget Function(BuildContext context, A valueA, B valueB, C valueC, Widget? child) builder;
  final Widget? child;

  @override
  State<ValueListenableBuilder3<A, B, C>> createState() => _ValueListenableBuilder3State<A, B, C>();
}

class _ValueListenableBuilder3State<A, B, C> extends State<ValueListenableBuilder3<A, B, C>> {
  late A valueA;
  late B valueB;
  late C valueC;

  @override
  void initState() {
    super.initState();
    valueA = widget.listenableA.value;
    valueB = widget.listenableB.value;
    valueC = widget.listenableC.value;
    widget.listenableA.addListener(_onValueChanged);
    widget.listenableB.addListener(_onValueChanged);
    widget.listenableC.addListener(_onValueChanged);
  }

  @override
  void didUpdateWidget(covariant ValueListenableBuilder3<A, B, C> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listenableA != widget.listenableA) {
      oldWidget.listenableA.removeListener(_onValueChanged);
      valueA = widget.listenableA.value;
      widget.listenableA.addListener(_onValueChanged);
    }
    if (oldWidget.listenableB != widget.listenableB) {
      oldWidget.listenableB.removeListener(_onValueChanged);
      valueB = widget.listenableB.value;
      widget.listenableB.addListener(_onValueChanged);
    }
    if (oldWidget.listenableC != widget.listenableC) {
      oldWidget.listenableC.removeListener(_onValueChanged);
      valueC = widget.listenableC.value;
      widget.listenableC.addListener(_onValueChanged);
    }
  }

  @override
  void dispose() {
    widget.listenableA.removeListener(_onValueChanged);
    widget.listenableB.removeListener(_onValueChanged);
    widget.listenableC.removeListener(_onValueChanged);
    super.dispose();
  }

  void _onValueChanged() {
    final A oldA = valueA;
    final B oldB = valueB;
    final C oldC = valueC;
    valueA = widget.listenableA.value;
    valueB = widget.listenableB.value;
    valueC = widget.listenableC.value;
    if (oldA == valueA && oldB == valueB && oldC == valueC) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, valueA, valueB, valueC, widget.child);
  }
}
