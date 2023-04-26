import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:april_flutter_utils/data/transformable_value_notifier.dart';

///同时监听两个数据观察者
class ValueListenableBuilder2<A, B> extends StatefulWidget {
  const ValueListenableBuilder2({
    super.key,
    required this.listenableA,
    required this.listenableB,
    this.needRebuild,
    required this.builder,
    this.child,
  });

  final ValueListenable<A> listenableA;
  final ValueListenable<B> listenableB;
  final bool Function(
    A oldA,
    A newA,
    B oldB,
    B newB,
  )? needRebuild;
  final Widget Function(
    BuildContext context,
    A valueA,
    B valueB,
    Widget? child,
  ) builder;
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
    _init();
  }

  void _init() {
    valueA = widget.listenableA.value;
    valueB = widget.listenableB.value;
    widget.listenableA.addListener(_onValueChanged);
    widget.listenableB.addListener(_onValueChanged);
  }

  void _onValueChanged() {
    final A oldA = valueA;
    final B oldB = valueB;
    valueA = widget.listenableA.value;
    valueB = widget.listenableB.value;
    if (widget.needRebuild?.call(
              oldA,
              valueA,
              oldB,
              valueB,
            ) !=
            false &&
        mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant ValueListenableBuilder2<A, B> oldWidget) {
    if (oldWidget.listenableA != widget.listenableA || oldWidget.listenableB != widget.listenableB) {
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
    super.key,
    required this.listenableA,
    required this.listenableB,
    required this.listenableC,
    this.needRebuild,
    required this.builder,
    this.child,
  });

  final ValueListenable<A> listenableA;
  final ValueListenable<B> listenableB;
  final ValueListenable<C> listenableC;
  final bool Function(
    A oldA,
    A newA,
    B oldB,
    B newB,
    C oldC,
    C newC,
  )? needRebuild;
  final Widget Function(
    BuildContext context,
    A valueA,
    B valueB,
    C valueC,
    Widget? child,
  ) builder;
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
    final A oldA = valueA;
    final B oldB = valueB;
    final C oldC = valueC;
    valueA = widget.listenableA.value;
    valueB = widget.listenableB.value;
    valueC = widget.listenableC.value;
    if (widget.needRebuild?.call(oldA, valueA, oldB, valueB, oldC, valueC) != false && mounted) {
      setState(() {});
    }
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

///监听 [A] 的变化，并返回 [R]
class TransformableListenableBuilder<A, R> extends StatefulWidget {
  const TransformableListenableBuilder({
    super.key,
    required this.source,
    required this.transformer,
    required this.builder,
    this.child,
  });

  final ValueListenable<A> source;
  final R Function(A sourceValue) transformer;
  final ValueWidgetBuilder<R> builder;
  final Widget? child;

  @override
  State<TransformableListenableBuilder<A, R>> createState() => _TransformableListenableBuilderState<A, R>();
}

class _TransformableListenableBuilderState<A, R> extends State<TransformableListenableBuilder<A, R>> {
  late ValueNotifier<R> notifier;

  @override
  void initState() {
    super.initState();
    notifier = widget.source.transform<R>(
      transformer: widget.transformer,
    );
  }

  @override
  void didUpdateWidget(TransformableListenableBuilder<A, R> oldWidget) {
    if (oldWidget.source != widget.source || oldWidget.transformer != widget.transformer) {
      notifier.dispose();
      notifier = widget.source.transform<R>(
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
    return ValueListenableBuilder<R>(
      valueListenable: notifier,
      builder: widget.builder,
      child: widget.child,
    );
  }
}

///根据两个数据观察者筛选出需要的数据
class TransformableListenableBuilder2<A, B, R> extends StatefulWidget {
  const TransformableListenableBuilder2({
    super.key,
    required this.sourceA,
    required this.sourceB,
    required this.transformer,
    required this.builder,
    this.child,
  });

  final ValueListenable<A> sourceA;
  final ValueListenable<B> sourceB;
  final R Function(A sourceValueA, B sourceValueB) transformer;
  final ValueWidgetBuilder<R> builder;
  final Widget? child;

  @override
  State<TransformableListenableBuilder2<A, B, R>> createState() => _TransformableListenableBuilder2State<A, B, R>();
}

class _TransformableListenableBuilder2State<A, B, R> extends State<TransformableListenableBuilder2<A, B, R>> {
  late ValueNotifier<R> notifier;

  @override
  void initState() {
    super.initState();
    notifier = TransformableValueNotifier2<A, B, R>(
      sourceA: widget.sourceA,
      sourceB: widget.sourceB,
      transformer: widget.transformer,
    );
  }

  @override
  void didUpdateWidget(covariant TransformableListenableBuilder2<A, B, R> oldWidget) {
    if (oldWidget.sourceA != widget.sourceA ||
        oldWidget.sourceB != widget.sourceB ||
        oldWidget.transformer != widget.transformer) {
      notifier.dispose();
      notifier = TransformableValueNotifier2<A, B, R>(
        sourceA: widget.sourceA,
        sourceB: widget.sourceB,
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
    return ValueListenableBuilder<R>(
      valueListenable: notifier,
      builder: widget.builder,
      child: widget.child,
    );
  }
}

///根据三个数据观察者筛选出需要的数据
class TransformableListenableBuilder3<A, B, C, S> extends StatefulWidget {
  const TransformableListenableBuilder3({
    super.key,
    required this.sourceA,
    required this.sourceB,
    required this.sourceC,
    required this.transformer,
    required this.builder,
    this.child,
  });

  final ValueListenable<A> sourceA;
  final ValueListenable<B> sourceB;
  final ValueListenable<C> sourceC;
  final S Function(A sourceValueA, B sourceValueB, C sourceValueC) transformer;
  final ValueWidgetBuilder<S> builder;
  final Widget? child;

  @override
  State<TransformableListenableBuilder3<A, B, C, S>> createState() =>
      _TransformableListenableBuilder3State<A, B, C, S>();
}

class _TransformableListenableBuilder3State<A, B, C, S> extends State<TransformableListenableBuilder3<A, B, C, S>> {
  late ValueNotifier<S> notifier;

  @override
  void initState() {
    super.initState();
    notifier = TransformableValueNotifier3<A, B, C, S>(
      sourceA: widget.sourceA,
      sourceB: widget.sourceB,
      sourceC: widget.sourceC,
      transformer: widget.transformer,
    );
  }

  @override
  void didUpdateWidget(covariant TransformableListenableBuilder3<A, B, C, S> oldWidget) {
    if (oldWidget.sourceA != widget.sourceA ||
        oldWidget.sourceB != widget.sourceB ||
        oldWidget.sourceC != widget.sourceC ||
        oldWidget.transformer != widget.transformer) {
      notifier.dispose();
      notifier = TransformableValueNotifier3<A, B, C, S>(
        sourceA: widget.sourceA,
        sourceB: widget.sourceB,
        sourceC: widget.sourceC,
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
      builder: widget.builder,
      child: widget.child,
    );
  }
}

///根据四个数据观察者筛选出需要的数据
class TransformableListenableBuilder4<A, B, C, D, S> extends StatefulWidget {
  const TransformableListenableBuilder4({
    super.key,
    required this.sourceA,
    required this.sourceB,
    required this.sourceC,
    required this.sourceD,
    required this.transformer,
    required this.builder,
    this.child,
  });

  final ValueListenable<A> sourceA;
  final ValueListenable<B> sourceB;
  final ValueListenable<C> sourceC;
  final ValueListenable<D> sourceD;
  final S Function(A sourceValueA, B sourceValueB, C sourceValueC, D sourceValueD) transformer;
  final ValueWidgetBuilder<S> builder;
  final Widget? child;

  @override
  State<TransformableListenableBuilder4<A, B, C, D, S>> createState() =>
      _TransformableListenableBuilder4State<A, B, C, D, S>();
}

class _TransformableListenableBuilder4State<A, B, C, D, S>
    extends State<TransformableListenableBuilder4<A, B, C, D, S>> {
  late ValueNotifier<S> notifier;

  @override
  void initState() {
    super.initState();
    notifier = TransformableValueNotifier4<A, B, C, D, S>(
      sourceA: widget.sourceA,
      sourceB: widget.sourceB,
      sourceC: widget.sourceC,
      sourceD: widget.sourceD,
      transformer: widget.transformer,
    );
  }

  @override
  void didUpdateWidget(covariant TransformableListenableBuilder4<A, B, C, D, S> oldWidget) {
    if (oldWidget.sourceA != widget.sourceA ||
        oldWidget.sourceB != widget.sourceB ||
        oldWidget.sourceC != widget.sourceC ||
        oldWidget.sourceD != widget.sourceD ||
        oldWidget.transformer != widget.transformer) {
      notifier.dispose();
      notifier = TransformableValueNotifier4<A, B, C, D, S>(
        sourceA: widget.sourceA,
        sourceB: widget.sourceB,
        sourceC: widget.sourceC,
        sourceD: widget.sourceD,
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
      builder: widget.builder,
      child: widget.child,
    );
  }
}

extension TransformableListenableBuilderExt<T> on ValueListenable<T> {
  TransformableListenableBuilder<T, D> transformBuilder<D>({
    Key? key,
    required D Function(T sourceValue) transformer,
    required ValueWidgetBuilder<D> builder,
    Widget? child,
  }) =>
      TransformableListenableBuilder<T, D>(
        key: key,
        source: this,
        transformer: transformer,
        builder: builder,
        child: child,
      );
}
