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
  late R value;

  @override
  void initState() {
    super.initState();
    value = widget.transformer.call(widget.source.value);
    widget.source.addListener(_onValueChanged);
  }

  @override
  void didUpdateWidget(TransformableListenableBuilder<A, R> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source.removeListener(_onValueChanged);
      value = widget.transformer.call(widget.source.value);
      widget.source.addListener(_onValueChanged);
    }
  }

  @override
  void dispose() {
    widget.source.removeListener(_onValueChanged);
    super.dispose();
  }

  void _onValueChanged() {
    final R newValue = widget.transformer.call(widget.source.value);
    if (value == newValue) {
      return;
    }
    value = newValue;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, value, widget.child);
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
  late R value;

  @override
  void initState() {
    super.initState();
    value = widget.transformer.call(
      widget.sourceA.value,
      widget.sourceB.value,
    );
    widget.sourceA.addListener(_onValueChanged);
    widget.sourceB.addListener(_onValueChanged);
  }

  @override
  void didUpdateWidget(covariant TransformableListenableBuilder2<A, B, R> oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool changed = false;
    if (oldWidget.sourceA != widget.sourceA) {
      changed = true;
      oldWidget.sourceA.removeListener(_onValueChanged);
      widget.sourceA.addListener(_onValueChanged);
    }
    if (oldWidget.sourceB != widget.sourceB) {
      changed = true;
      oldWidget.sourceB.removeListener(_onValueChanged);
      widget.sourceB.addListener(_onValueChanged);
    }
    if (changed) {
      value = widget.transformer.call(
        widget.sourceA.value,
        widget.sourceB.value,
      );
    }
  }

  @override
  void dispose() {
    widget.sourceA.removeListener(_onValueChanged);
    widget.sourceB.removeListener(_onValueChanged);
    super.dispose();
  }

  void _onValueChanged() {
    final R newValue = widget.transformer.call(
      widget.sourceA.value,
      widget.sourceB.value,
    );
    if (value == newValue) {
      return;
    }
    value = newValue;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, value, widget.child);
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
  late S value;

  @override
  void initState() {
    super.initState();
    value = widget.transformer.call(
      widget.sourceA.value,
      widget.sourceB.value,
      widget.sourceC.value,
    );
    widget.sourceA.addListener(_onValueChanged);
    widget.sourceB.addListener(_onValueChanged);
    widget.sourceC.addListener(_onValueChanged);
  }

  @override
  void didUpdateWidget(covariant TransformableListenableBuilder3<A, B, C, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool changed = false;
    if (oldWidget.sourceA != widget.sourceA) {
      changed = true;
      oldWidget.sourceA.removeListener(_onValueChanged);
      widget.sourceA.addListener(_onValueChanged);
    }
    if (oldWidget.sourceB != widget.sourceB) {
      changed = true;
      oldWidget.sourceB.removeListener(_onValueChanged);
      widget.sourceB.addListener(_onValueChanged);
    }
    if (oldWidget.sourceC != widget.sourceC) {
      changed = true;
      oldWidget.sourceC.removeListener(_onValueChanged);
      widget.sourceC.addListener(_onValueChanged);
    }
    if (changed) {
      value = widget.transformer.call(
        widget.sourceA.value,
        widget.sourceB.value,
        widget.sourceC.value,
      );
    }
  }

  @override
  void dispose() {
    widget.sourceA.removeListener(_onValueChanged);
    widget.sourceB.removeListener(_onValueChanged);
    widget.sourceC.removeListener(_onValueChanged);
    super.dispose();
  }

  void _onValueChanged() {
    final S newValue = widget.transformer.call(
      widget.sourceA.value,
      widget.sourceB.value,
      widget.sourceC.value,
    );
    if (value == newValue) {
      return;
    }
    value = newValue;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, value, widget.child);
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
  late S value;

  @override
  void initState() {
    super.initState();
    value = widget.transformer.call(
      widget.sourceA.value,
      widget.sourceB.value,
      widget.sourceC.value,
      widget.sourceD.value,
    );
    widget.sourceA.addListener(_onValueChanged);
    widget.sourceB.addListener(_onValueChanged);
    widget.sourceC.addListener(_onValueChanged);
    widget.sourceD.addListener(_onValueChanged);
  }

  @override
  void didUpdateWidget(covariant TransformableListenableBuilder4<A, B, C, D, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool changed = false;
    if (oldWidget.sourceA != widget.sourceA) {
      changed = true;
      oldWidget.sourceA.removeListener(_onValueChanged);
      widget.sourceA.addListener(_onValueChanged);
    }
    if (oldWidget.sourceB != widget.sourceB) {
      changed = true;
      oldWidget.sourceB.removeListener(_onValueChanged);
      widget.sourceB.addListener(_onValueChanged);
    }
    if (oldWidget.sourceC != widget.sourceC) {
      changed = true;
      oldWidget.sourceC.removeListener(_onValueChanged);
      widget.sourceC.addListener(_onValueChanged);
    }
    if (oldWidget.sourceD != widget.sourceD) {
      changed = true;
      oldWidget.sourceD.removeListener(_onValueChanged);
      widget.sourceD.addListener(_onValueChanged);
    }
    if (changed) {
      value = widget.transformer.call(
        widget.sourceA.value,
        widget.sourceB.value,
        widget.sourceC.value,
        widget.sourceD.value,
      );
    }
  }

  @override
  void dispose() {
    widget.sourceA.removeListener(_onValueChanged);
    widget.sourceB.removeListener(_onValueChanged);
    widget.sourceC.removeListener(_onValueChanged);
    widget.sourceD.removeListener(_onValueChanged);
    super.dispose();
  }

  void _onValueChanged() {
    final S newValue = widget.transformer.call(
      widget.sourceA.value,
      widget.sourceB.value,
      widget.sourceC.value,
      widget.sourceD.value,
    );
    if (value == newValue) {
      return;
    }
    value = newValue;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, value, widget.child);
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
