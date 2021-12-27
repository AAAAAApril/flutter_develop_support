import 'package:april/data/transformed_listenable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

///和 [ValueListenableBuilder] 作用一样，只不过这个会筛选出需要的数据
class TransformedListenableBuilder<T, D> extends StatefulWidget {
  const TransformedListenableBuilder({
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
  _TransformedListenableBuilderState<T, D> createState() =>
      _TransformedListenableBuilderState<T, D>();
}

class _TransformedListenableBuilderState<T, D>
    extends State<TransformedListenableBuilder<T, D>> {
  late TransformedValueNotifier<T, D> notifier;

  @override
  void initState() {
    super.initState();
    notifier = TransformedValueNotifier<T, D>(
      listenable: widget.listenable,
      transformer: widget.transformer,
    );
  }

  @override
  void didUpdateWidget(TransformedListenableBuilder<T, D> oldWidget) {
    if (oldWidget.listenable != widget.listenable) {
      notifier.dispose();
      notifier = TransformedValueNotifier<T, D>(
        listenable: widget.listenable,
        transformer: widget.transformer,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<D>(
      valueListenable: notifier,
      child: widget.child,
      builder: widget.builder,
    );
  }
}

///根据两个数据观察者筛选出需要的数据
class TransformedListenableBuilder2<A, B, S> extends StatefulWidget {
  const TransformedListenableBuilder2({
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
  _TransformedListenableBuilder2State<A, B, S> createState() =>
      _TransformedListenableBuilder2State<A, B, S>();
}

class _TransformedListenableBuilder2State<A, B, S>
    extends State<TransformedListenableBuilder2<A, B, S>> {
  late TransformedValueNotifier2<A, B, S> notifier;

  @override
  void initState() {
    super.initState();
    notifier = TransformedValueNotifier2<A, B, S>(
      listenableA: widget.listenableA,
      listenableB: widget.listenableB,
      transformer: widget.transformer,
    );
  }

  @override
  void didUpdateWidget(
    covariant TransformedListenableBuilder2<A, B, S> oldWidget,
  ) {
    if (oldWidget.listenableA != widget.listenableA ||
        oldWidget.listenableB != widget.listenableB) {
      notifier.dispose();
      notifier = TransformedValueNotifier2<A, B, S>(
        listenableA: widget.listenableA,
        listenableB: widget.listenableB,
        transformer: widget.transformer,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<S>(
      valueListenable: notifier,
      child: widget.child,
      builder: widget.builder,
    );
  }
}

///根据三个数据观察者筛选出需要的数据
class TransformedListenableBuilder3<A, B, C, S> extends StatefulWidget {
  const TransformedListenableBuilder3({
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
  _TransformedListenableBuilder3State<A, B, C, S> createState() =>
      _TransformedListenableBuilder3State<A, B, C, S>();
}

class _TransformedListenableBuilder3State<A, B, C, S>
    extends State<TransformedListenableBuilder3<A, B, C, S>> {
  late TransformedValueNotifier3<A, B, C, S> notifier;

  @override
  void initState() {
    super.initState();
    notifier = TransformedValueNotifier3<A, B, C, S>(
      listenableA: widget.listenableA,
      listenableB: widget.listenableB,
      listenableC: widget.listenableC,
      transformer: widget.transformer,
    );
  }

  @override
  void didUpdateWidget(
    covariant TransformedListenableBuilder3<A, B, C, S> oldWidget,
  ) {
    if (oldWidget.listenableA != widget.listenableA ||
        oldWidget.listenableB != widget.listenableB ||
        oldWidget.listenableC != widget.listenableC) {
      notifier.dispose();
      notifier = TransformedValueNotifier3<A, B, C, S>(
        listenableA: widget.listenableA,
        listenableB: widget.listenableB,
        listenableC: widget.listenableC,
        transformer: widget.transformer,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<S>(
      valueListenable: notifier,
      child: widget.child,
      builder: widget.builder,
    );
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
