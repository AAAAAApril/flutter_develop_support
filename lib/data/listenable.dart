import 'package:flutter/foundation.dart';

///同时监听两个监听器，并合并其值
class MultiValueNotifier<A, B, R> extends ValueNotifier<R> {
  MultiValueNotifier(
    R value, {
    required this.listenableA,
    required this.listenableB,
    required R Function(A, B) onValueChanged,
  })  : _onValueChanged = onValueChanged,
        super(value) {
    listenableA.addListener(_onNewValue);
    listenableB.addListener(_onNewValue);
  }

  ///监听器 A
  final ValueListenable<A> listenableA;

  ///监听器 B
  final ValueListenable<B> listenableB;

  ///数据变更
  final R Function(A, B) _onValueChanged;

  void _onNewValue() {
    value = _onValueChanged.call(
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
