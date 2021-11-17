import 'package:flutter/foundation.dart';

///监听一个监听器，得到另一个值
class TransformValueNotifier<T, D> extends ValueNotifier<D> {
  TransformValueNotifier(
    D value, {
    required ValueListenable<T> targetListenable,
    required D Function(T value) transformer,
  })  : _listenable = targetListenable,
        _transformer = transformer,
        super(value) {
    _onNewValue();
    _listenable.addListener(_onNewValue);
  }

  ///监听器
  final ValueListenable<T> _listenable;

  ///转换器
  final D Function(T value) _transformer;

  ///有新值
  void _onNewValue() {
    value = _transformer.call(
      _listenable.value,
    );
  }

  @override
  void dispose() {
    _listenable.removeListener(_onNewValue);
    super.dispose();
  }
}

///同时监听两个监听器，并转换其值
class TransformValueNotifier2<A, B, R> extends ValueNotifier<R> {
  TransformValueNotifier2(
    R value, {
    required this.listenableA,
    required this.listenableB,
    required R Function(A valueA, B valueB) transformer,
  })  : _transformer = transformer,
        super(value) {
    _onNewValue();
    listenableA.addListener(_onNewValue);
    listenableB.addListener(_onNewValue);
  }

  ///监听器 A
  final ValueListenable<A> listenableA;

  ///监听器 B
  final ValueListenable<B> listenableB;

  ///转换器
  final R Function(A, B) _transformer;

  void _onNewValue() {
    value = _transformer.call(
      listenableA.value,
      listenableB.value,
    );
  }

  @override
  void dispose() {
    listenableA.removeListener(_onNewValue);
    listenableB.removeListener(_onNewValue);
    super.dispose();
  }
}

///同时监听三个监听器，并转换其值
class TransformValueNotifier3<A, B, C, R> extends ValueNotifier<R> {
  TransformValueNotifier3(
    R value, {
    required this.listenableA,
    required this.listenableB,
    required this.listenableC,
    required R Function(A valueA, B valueB, C valueC) transformer,
  })  : _transformer = transformer,
        super(value) {
    _onNewValue();
    listenableA.addListener(_onNewValue);
    listenableB.addListener(_onNewValue);
    listenableC.addListener(_onNewValue);
  }

  ///监听器 A
  final ValueListenable<A> listenableA;

  ///监听器 B
  final ValueListenable<B> listenableB;

  ///监听器 C
  final ValueListenable<C> listenableC;

  ///转换器
  final R Function(A, B, C) _transformer;

  void _onNewValue() {
    value = _transformer.call(
      listenableA.value,
      listenableB.value,
      listenableC.value,
    );
  }

  @override
  void dispose() {
    listenableA.removeListener(_onNewValue);
    listenableB.removeListener(_onNewValue);
    listenableC.removeListener(_onNewValue);
    super.dispose();
  }
}
