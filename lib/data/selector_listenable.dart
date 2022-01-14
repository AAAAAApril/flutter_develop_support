import 'package:flutter/foundation.dart';

///监听一个监听器，得到另一个值
class SelectValueNotifier<T, D> extends ValueNotifier<D> {
  SelectValueNotifier({
    required ValueListenable<T> valueListenable,
    required D Function(T value) selector,
  })  : _valueListenable = valueListenable,
        _selector = selector,
        super(
          selector(
            valueListenable.value,
          ),
        ) {
    _valueListenable.addListener(_onNewValue);
  }

  ///监听器
  final ValueListenable<T> _valueListenable;

  ///转换器
  final D Function(T value) _selector;

  ///有新值
  void _onNewValue() {
    value = _selector.call(
      _valueListenable.value,
    );
  }

  @override
  void dispose() {
    _valueListenable.removeListener(_onNewValue);
    super.dispose();
  }
}

///同时监听两个监听器，并转换其值
class SelectValueNotifier2<A, B, R> extends ValueNotifier<R> {
  SelectValueNotifier2({
    required this.valueListenableA,
    required this.valueListenableB,
    required R Function(A valueA, B valueB) selector,
  })  : _selector = selector,
        super(
          selector(
            valueListenableA.value,
            valueListenableB.value,
          ),
        ) {
    valueListenableA.addListener(_onNewValue);
    valueListenableB.addListener(_onNewValue);
  }

  ///监听器 A
  final ValueListenable<A> valueListenableA;

  ///监听器 B
  final ValueListenable<B> valueListenableB;

  ///转换器
  final R Function(A, B) _selector;

  void _onNewValue() {
    value = _selector.call(
      valueListenableA.value,
      valueListenableB.value,
    );
  }

  @override
  void dispose() {
    valueListenableA.removeListener(_onNewValue);
    valueListenableB.removeListener(_onNewValue);
    super.dispose();
  }
}

///同时监听三个监听器，并转换其值
class SelectValueNotifier3<A, B, C, R> extends ValueNotifier<R> {
  SelectValueNotifier3({
    required this.valueListenableA,
    required this.valueListenableB,
    required this.valueListenableC,
    required R Function(A valueA, B valueB, C valueC) selector,
  })  : _selector = selector,
        super(
          selector(
            valueListenableA.value,
            valueListenableB.value,
            valueListenableC.value,
          ),
        ) {
    valueListenableA.addListener(_onNewValue);
    valueListenableB.addListener(_onNewValue);
    valueListenableC.addListener(_onNewValue);
  }

  ///监听器 A
  final ValueListenable<A> valueListenableA;

  ///监听器 B
  final ValueListenable<B> valueListenableB;

  ///监听器 C
  final ValueListenable<C> valueListenableC;

  ///转换器
  final R Function(A, B, C) _selector;

  void _onNewValue() {
    value = _selector.call(
      valueListenableA.value,
      valueListenableB.value,
      valueListenableC.value,
    );
  }

  @override
  void dispose() {
    valueListenableA.removeListener(_onNewValue);
    valueListenableB.removeListener(_onNewValue);
    valueListenableC.removeListener(_onNewValue);
    super.dispose();
  }
}
