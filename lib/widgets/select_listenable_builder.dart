import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef ListenableSelector<T, D> = D Function(T value);

///和 [ValueListenableBuilder] 作用一样，只不过这个会筛选出需要的数据
class SelectListenableBuilder<T, D> extends StatefulWidget {
  const SelectListenableBuilder({
    Key? key,
    required this.valueListenable,
    required this.selector,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<T> valueListenable;
  final ListenableSelector<T, D> selector;
  final ValueWidgetBuilder<D> builder;
  final Widget? child;

  @override
  _SelectListenableBuilderState<T, D> createState() =>
      _SelectListenableBuilderState<T, D>();
}

class _SelectListenableBuilderState<T, D>
    extends State<SelectListenableBuilder<T, D>> {
  late D value;

  @override
  void initState() {
    super.initState();
    value = widget.selector.call(widget.valueListenable.value);
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(SelectListenableBuilder<T, D> oldWidget) {
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      value = widget.selector.call(widget.valueListenable.value);
      widget.valueListenable.addListener(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    D newData = widget.selector.call(widget.valueListenable.value);
    if (newData != value) {
      value = newData;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, widget.child);
  }
}

typedef ListenableSelector2<A, B, S> = S Function(A aValue, B bValue);

///根据两个数据观察者筛选出需要的数据
class SelectListenableBuilder2<A, B, S> extends StatefulWidget {
  const SelectListenableBuilder2({
    Key? key,
    required this.valueListenableA,
    required this.valueListenableB,
    required this.selector,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> valueListenableA;
  final ValueListenable<B> valueListenableB;
  final ListenableSelector2<A, B, S> selector;
  final ValueWidgetBuilder<S> builder;
  final Widget? child;

  @override
  _SelectListenableBuilder2State<A, B, S> createState() =>
      _SelectListenableBuilder2State<A, B, S>();
}

class _SelectListenableBuilder2State<A, B, S>
    extends State<SelectListenableBuilder2<A, B, S>> {
  late S result;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    result = _calculate();
    widget.valueListenableA.addListener(onValueChanged);
    widget.valueListenableB.addListener(onValueChanged);
  }

  S _calculate() {
    return widget.selector.call(
      widget.valueListenableA.value,
      widget.valueListenableB.value,
    );
  }

  void onValueChanged() {
    final result = _calculate();
    if (result != this.result) {
      this.result = result;
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant SelectListenableBuilder2<A, B, S> oldWidget) {
    if (oldWidget.valueListenableA != widget.valueListenableA ||
        oldWidget.valueListenableB != widget.valueListenableB) {
      _release(oldWidget);
      _init();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _release(SelectListenableBuilder2<A, B, S> widget) {
    widget.valueListenableA.removeListener(onValueChanged);
    widget.valueListenableB.removeListener(onValueChanged);
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
