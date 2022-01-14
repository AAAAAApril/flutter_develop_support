import 'package:april/data/selector_listenable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

///同时监听两个数据观察者
class ValueListenableBuilder2<A, B> extends StatefulWidget {
  const ValueListenableBuilder2({
    Key? key,
    required this.listenableA,
    required this.listenableB,
    this.needRebuild,
    required this.builder,
    this.child,
  }) : super(key: key);

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
    this.needRebuild,
    required this.builder,
    this.child,
  }) : super(key: key);

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
    final A oldA = valueA;
    final B oldB = valueB;
    final C oldC = valueC;
    valueA = widget.listenableA.value;
    valueB = widget.listenableB.value;
    valueC = widget.listenableC.value;
    if (widget.needRebuild?.call(
              oldA,
              valueA,
              oldB,
              valueB,
              oldC,
              valueC,
            ) !=
            false &&
        mounted) {
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

///监听 [T] 的变化，并返回 [D]
class SelectorListenableBuilder<T, D> extends StatefulWidget {
  const SelectorListenableBuilder({
    Key? key,
    required this.valueListenable,
    required this.selector,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<T> valueListenable;
  final D Function(T value) selector;
  final ValueWidgetBuilder<D> builder;
  final Widget? child;

  @override
  _SelectorListenableBuilderState<T, D> createState() =>
      _SelectorListenableBuilderState<T, D>();
}

class _SelectorListenableBuilderState<T, D>
    extends State<SelectorListenableBuilder<T, D>> {
  late SelectValueNotifier<T, D> notifier;

  @override
  void initState() {
    super.initState();
    notifier = SelectValueNotifier<T, D>(
      valueListenable: widget.valueListenable,
      selector: widget.selector,
    );
  }

  @override
  void didUpdateWidget(SelectorListenableBuilder<T, D> oldWidget) {
    if (oldWidget.valueListenable != widget.valueListenable) {
      notifier.dispose();
      notifier = SelectValueNotifier<T, D>(
        valueListenable: widget.valueListenable,
        selector: widget.selector,
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
class SelectorListenableBuilder2<A, B, S> extends StatefulWidget {
  const SelectorListenableBuilder2({
    Key? key,
    required this.valueListenableA,
    required this.valueListenableB,
    required this.selector,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> valueListenableA;
  final ValueListenable<B> valueListenableB;
  final S Function(A valueA, B valueB) selector;
  final ValueWidgetBuilder<S> builder;
  final Widget? child;

  @override
  _SelectorListenableBuilder2State<A, B, S> createState() =>
      _SelectorListenableBuilder2State<A, B, S>();
}

class _SelectorListenableBuilder2State<A, B, S>
    extends State<SelectorListenableBuilder2<A, B, S>> {
  late SelectValueNotifier2<A, B, S> notifier;

  @override
  void initState() {
    super.initState();
    notifier = SelectValueNotifier2<A, B, S>(
      valueListenableA: widget.valueListenableA,
      valueListenableB: widget.valueListenableB,
      selector: widget.selector,
    );
  }

  @override
  void didUpdateWidget(
    covariant SelectorListenableBuilder2<A, B, S> oldWidget,
  ) {
    if (oldWidget.valueListenableA != widget.valueListenableA ||
        oldWidget.valueListenableB != widget.valueListenableB) {
      notifier.dispose();
      notifier = SelectValueNotifier2<A, B, S>(
        valueListenableA: widget.valueListenableA,
        valueListenableB: widget.valueListenableB,
        selector: widget.selector,
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
class SelectorListenableBuilder3<A, B, C, S> extends StatefulWidget {
  const SelectorListenableBuilder3({
    Key? key,
    required this.valueListenableA,
    required this.valueListenableB,
    required this.valueListenableC,
    required this.selector,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> valueListenableA;
  final ValueListenable<B> valueListenableB;
  final ValueListenable<C> valueListenableC;
  final S Function(A valueA, B valueB, C valueC) selector;
  final ValueWidgetBuilder<S> builder;
  final Widget? child;

  @override
  _SelectorListenableBuilder3State<A, B, C, S> createState() =>
      _SelectorListenableBuilder3State<A, B, C, S>();
}

class _SelectorListenableBuilder3State<A, B, C, S>
    extends State<SelectorListenableBuilder3<A, B, C, S>> {
  late SelectValueNotifier3<A, B, C, S> notifier;

  @override
  void initState() {
    super.initState();
    notifier = SelectValueNotifier3<A, B, C, S>(
      valueListenableA: widget.valueListenableA,
      valueListenableB: widget.valueListenableB,
      valueListenableC: widget.valueListenableC,
      selector: widget.selector,
    );
  }

  @override
  void didUpdateWidget(
    covariant SelectorListenableBuilder3<A, B, C, S> oldWidget,
  ) {
    if (oldWidget.valueListenableA != widget.valueListenableA ||
        oldWidget.valueListenableB != widget.valueListenableB ||
        oldWidget.valueListenableC != widget.valueListenableC) {
      notifier.dispose();
      notifier = SelectValueNotifier3<A, B, C, S>(
        valueListenableA: widget.valueListenableA,
        valueListenableB: widget.valueListenableB,
        valueListenableC: widget.valueListenableC,
        selector: widget.selector,
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

///和 [ValueListenableBuilder] 作用一样，只不过这个会筛选出需要的数据
@Deprecated('use SelectorListenableBuilder<T, D> instead')
class TransformedListenableBuilder<T, D>
    extends SelectorListenableBuilder<T, D> {
  const TransformedListenableBuilder({
    Key? key,
    required ValueListenable<T> listenable,
    required D Function(T value) transformer,
    required ValueWidgetBuilder<D> builder,
    Widget? child,
  }) : super(
          key: key,
          valueListenable: listenable,
          selector: transformer,
          builder: builder,
          child: child,
        );
}

///根据两个数据观察者筛选出需要的数据
@Deprecated('use SelectorListenableBuilder2<A, B, S> instead')
class TransformedListenableBuilder2<A, B, S>
    extends SelectorListenableBuilder2<A, B, S> {
  const TransformedListenableBuilder2({
    Key? key,
    required ValueListenable<A> listenableA,
    required ValueListenable<B> listenableB,
    required S Function(A valueA, B valueB) transformer,
    required ValueWidgetBuilder<S> builder,
    Widget? child,
  }) : super(
          key: key,
          valueListenableA: listenableA,
          valueListenableB: listenableB,
          selector: transformer,
          builder: builder,
          child: child,
        );
}

///根据三个数据观察者筛选出需要的数据
@Deprecated('use SelectorListenableBuilder3<A, B, C, S> instead')
class TransformedListenableBuilder3<A, B, C, S>
    extends SelectorListenableBuilder3<A, B, C, S> {
  const TransformedListenableBuilder3({
    Key? key,
    required ValueListenable<A> listenableA,
    required ValueListenable<B> listenableB,
    required ValueListenable<C> listenableC,
    required S Function(A valueA, B valueB, C valueC) transformer,
    required ValueWidgetBuilder<S> builder,
    Widget? child,
  }) : super(
          key: key,
          valueListenableA: listenableA,
          valueListenableB: listenableB,
          valueListenableC: listenableC,
          selector: transformer,
          builder: builder,
          child: child,
        );
}
