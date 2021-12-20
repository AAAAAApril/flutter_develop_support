import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

///和 [ValueListenableBuilder] 作用一样，只不过这个会筛选出需要的数据
class TransformListenableBuilder<T, D> extends StatefulWidget {
  const TransformListenableBuilder({
    Key? key,
    required this.listenable,
    required this.transformer,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<T> listenable;
  final D Function(T value) transformer;
  final ValueWidgetBuilder<D> builder;
  final Widget? child;

  @override
  _TransformListenableBuilderState<T, D> createState() =>
      _TransformListenableBuilderState<T, D>();
}

class _TransformListenableBuilderState<T, D>
    extends State<TransformListenableBuilder<T, D>> {
  late D value;

  @override
  void initState() {
    super.initState();
    value = widget.transformer.call(widget.listenable.value);
    widget.listenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(TransformListenableBuilder<T, D> oldWidget) {
    if (oldWidget.listenable != widget.listenable) {
      oldWidget.listenable.removeListener(_valueChanged);
      value = widget.transformer.call(widget.listenable.value);
      widget.listenable.addListener(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.listenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    D newData = widget.transformer.call(widget.listenable.value);
    if (newData != value) {
      value = newData;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, widget.child);
  }
}

///根据两个数据观察者筛选出需要的数据
class TransformListenableBuilder2<A, B, S> extends StatefulWidget {
  const TransformListenableBuilder2({
    Key? key,
    required this.listenableA,
    required this.listenableB,
    required this.transformer,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> listenableA;
  final ValueListenable<B> listenableB;
  final S Function(A aValue, B bValue) transformer;
  final ValueWidgetBuilder<S> builder;
  final Widget? child;

  @override
  _TransformListenableBuilder2State<A, B, S> createState() =>
      _TransformListenableBuilder2State<A, B, S>();
}

class _TransformListenableBuilder2State<A, B, S>
    extends State<TransformListenableBuilder2<A, B, S>> {
  late S result;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    result = _calculate();
    widget.listenableA.addListener(onValueChanged);
    widget.listenableB.addListener(onValueChanged);
  }

  S _calculate() {
    return widget.transformer.call(
      widget.listenableA.value,
      widget.listenableB.value,
    );
  }

  void onValueChanged() {
    final result = _calculate();
    if (result != this.result) {
      this.result = result;
      if (mounted) setState(() {});
    }
  }

  @override
  void didUpdateWidget(
      covariant TransformListenableBuilder2<A, B, S> oldWidget) {
    if (oldWidget.listenableA != widget.listenableA ||
        oldWidget.listenableB != widget.listenableB) {
      _release(oldWidget);
      _init();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _release(TransformListenableBuilder2<A, B, S> widget) {
    widget.listenableA.removeListener(onValueChanged);
    widget.listenableB.removeListener(onValueChanged);
  }

  @override
  void dispose() {
    _release(widget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, result, widget.child);
  }
}

///根据三个数据观察者筛选出需要的数据
class TransformListenableBuilder3<A, B, C, S> extends StatefulWidget {
  const TransformListenableBuilder3({
    Key? key,
    required this.listenableA,
    required this.listenableB,
    required this.listenableC,
    required this.transformer,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> listenableA;
  final ValueListenable<B> listenableB;
  final ValueListenable<C> listenableC;
  final S Function(A aValue, B bValue, C valueC) transformer;
  final ValueWidgetBuilder<S> builder;
  final Widget? child;

  @override
  _TransformListenableBuilder3State<A, B, C, S> createState() =>
      _TransformListenableBuilder3State<A, B, C, S>();
}

class _TransformListenableBuilder3State<A, B, C, S>
    extends State<TransformListenableBuilder3<A, B, C, S>> {
  late S result;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    result = _calculate();
    widget.listenableA.addListener(onValueChanged);
    widget.listenableB.addListener(onValueChanged);
    widget.listenableC.addListener(onValueChanged);
  }

  S _calculate() {
    return widget.transformer.call(
      widget.listenableA.value,
      widget.listenableB.value,
      widget.listenableC.value,
    );
  }

  void onValueChanged() {
    final result = _calculate();
    if (result != this.result) {
      this.result = result;
      if (mounted) setState(() {});
    }
  }

  @override
  void didUpdateWidget(
    covariant TransformListenableBuilder3<A, B, C, S> oldWidget,
  ) {
    if (oldWidget.listenableA != widget.listenableA ||
        oldWidget.listenableB != widget.listenableB ||
        oldWidget.listenableC != widget.listenableC) {
      _release(oldWidget);
      _init();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _release(TransformListenableBuilder3<A, B, C, S> widget) {
    widget.listenableA.removeListener(onValueChanged);
    widget.listenableB.removeListener(onValueChanged);
    widget.listenableC.removeListener(onValueChanged);
  }

  @override
  void dispose() {
    _release(widget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, result, widget.child);
  }
}

///同时监听两个数据观察者
class ValueListenableBuilder2<A, B> extends StatefulWidget {
  const ValueListenableBuilder2({
    Key? key,
    required this.listenableA,
    required this.listenableB,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> listenableA;
  final ValueListenable<B> listenableB;
  final Widget Function(
    BuildContext context,
    A valueA,
    B valueB,
    Widget? child,
  ) builder;
  final Widget? child;

  @override
  _ValueListenableBuilder2State<A, B> createState() =>
      _ValueListenableBuilder2State<A, B>();
}

class _ValueListenableBuilder2State<A, B>
    extends State<ValueListenableBuilder2<A, B>> {
  late A valueA;
  late B valueB;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    valueA = widget.listenableA.value;
    valueB = widget.listenableB.value;
    widget.listenableA.addListener(_onValueChanged);
    widget.listenableB.addListener(_onValueChanged);
  }

  void _onValueChanged() {
    valueA = widget.listenableA.value;
    valueB = widget.listenableB.value;
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant ValueListenableBuilder2<A, B> oldWidget) {
    if (oldWidget.listenableA != widget.listenableA ||
        oldWidget.listenableB != widget.listenableB) {
      _release(oldWidget);
      _init();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _release(ValueListenableBuilder2<A, B> widget) {
    widget.listenableA.removeListener(_onValueChanged);
    widget.listenableB.removeListener(_onValueChanged);
  }

  @override
  void dispose() {
    _release(widget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(
      context,
      valueA,
      valueB,
      widget.child,
    );
  }
}

///同时监听三个数据观察者
class ValueListenableBuilder3<A, B, C> extends StatefulWidget {
  const ValueListenableBuilder3({
    Key? key,
    required this.listenableA,
    required this.listenableB,
    required this.listenableC,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> listenableA;
  final ValueListenable<B> listenableB;
  final ValueListenable<C> listenableC;
  final Widget Function(
    BuildContext context,
    A valueA,
    B valueB,
    C valueC,
    Widget? child,
  ) builder;
  final Widget? child;

  @override
  _ValueListenableBuildere3State<A, B, C> createState() =>
      _ValueListenableBuildere3State<A, B, C>();
}

class _ValueListenableBuildere3State<A, B, C>
    extends State<ValueListenableBuilder3<A, B, C>> {
  late A valueA;
  late B valueB;
  late C valueC;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    valueA = widget.listenableA.value;
    valueB = widget.listenableB.value;
    valueC = widget.listenableC.value;
    widget.listenableA.addListener(_onValueChanged);
    widget.listenableB.addListener(_onValueChanged);
    widget.listenableC.addListener(_onValueChanged);
  }

  void _onValueChanged() {
    valueA = widget.listenableA.value;
    valueB = widget.listenableB.value;
    valueC = widget.listenableC.value;
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant ValueListenableBuilder3<A, B, C> oldWidget) {
    if (oldWidget.listenableA != widget.listenableA ||
        oldWidget.listenableB != widget.listenableB ||
        oldWidget.listenableC != widget.listenableC) {
      _release(oldWidget);
      _init();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _release(ValueListenableBuilder3<A, B, C> widget) {
    widget.listenableA.removeListener(_onValueChanged);
    widget.listenableB.removeListener(_onValueChanged);
    widget.listenableC.removeListener(_onValueChanged);
  }

  @override
  void dispose() {
    _release(widget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(
      context,
      valueA,
      valueB,
      valueC,
      widget.child,
    );
  }
}
