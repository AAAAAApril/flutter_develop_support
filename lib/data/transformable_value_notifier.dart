import 'package:flutter/foundation.dart';

///监听一个监听器，得到另一个值
class TransformableValueNotifier<A, R> extends ValueNotifier<R> {
  TransformableValueNotifier({
    required this.source,
    required this.transformer,
  }) : super(transformer(source.value)) {
    source.addListener(_onNewValue);
  }

  @override
  void dispose() {
    source.removeListener(_onNewValue);
    super.dispose();
  }

  final ValueListenable<A> source;
  final R Function(A sourceValue) transformer;

  void _onNewValue() {
    value = transformer.call(source.value);
  }
}

///同时监听两个监听器，并转换其值
class TransformableValueNotifier2<A, B, R> extends ValueNotifier<R> {
  TransformableValueNotifier2({
    required this.sourceA,
    required this.sourceB,
    required this.transformer,
  }) : super(transformer(sourceA.value, sourceB.value)) {
    sourceA.addListener(_onNewValue);
    sourceB.addListener(_onNewValue);
  }

  @override
  void dispose() {
    sourceA.removeListener(_onNewValue);
    sourceB.removeListener(_onNewValue);
    super.dispose();
  }

  final ValueListenable<A> sourceA;
  final ValueListenable<B> sourceB;
  final R Function(A sourceValueA, B sourceValueB) transformer;

  void _onNewValue() {
    value = transformer.call(
      sourceA.value,
      sourceB.value,
    );
  }
}

///同时监听三个监听器，并转换其值
class TransformableValueNotifier3<A, B, C, R> extends ValueNotifier<R> {
  TransformableValueNotifier3({
    required this.sourceA,
    required this.sourceB,
    required this.sourceC,
    required this.transformer,
  }) : super(transformer(sourceA.value, sourceB.value, sourceC.value)) {
    sourceA.addListener(_onNewValue);
    sourceB.addListener(_onNewValue);
    sourceC.addListener(_onNewValue);
  }

  @override
  void dispose() {
    sourceA.removeListener(_onNewValue);
    sourceB.removeListener(_onNewValue);
    sourceC.removeListener(_onNewValue);
    super.dispose();
  }

  final ValueListenable<A> sourceA;
  final ValueListenable<B> sourceB;
  final ValueListenable<C> sourceC;
  final R Function(A sourceValueA, B sourceValueB, C sourceValueC) transformer;

  void _onNewValue() {
    value = transformer.call(
      sourceA.value,
      sourceB.value,
      sourceC.value,
    );
  }
}

///同时监听四个监听器，并转换其值
class TransformableValueNotifier4<A, B, C, D, R> extends ValueNotifier<R> {
  TransformableValueNotifier4({
    required this.sourceA,
    required this.sourceB,
    required this.sourceC,
    required this.sourceD,
    required this.transformer,
  }) : super(transformer(
          sourceA.value,
          sourceB.value,
          sourceC.value,
          sourceD.value,
        )) {
    sourceA.addListener(_onNewValue);
    sourceB.addListener(_onNewValue);
    sourceC.addListener(_onNewValue);
    sourceD.addListener(_onNewValue);
  }

  @override
  void dispose() {
    sourceA.removeListener(_onNewValue);
    sourceB.removeListener(_onNewValue);
    sourceC.removeListener(_onNewValue);
    sourceD.removeListener(_onNewValue);
    super.dispose();
  }

  final ValueListenable<A> sourceA;
  final ValueListenable<B> sourceB;
  final ValueListenable<C> sourceC;
  final ValueListenable<D> sourceD;
  final R Function(
    A sourceValueA,
    B sourceValueB,
    C sourceValueC,
    D sourceValueD,
  ) transformer;

  void _onNewValue() {
    value = transformer.call(
      sourceA.value,
      sourceB.value,
      sourceC.value,
      sourceD.value,
    );
  }
}

extension TransformableValueListenableExt<T> on ValueListenable<T> {
  ValueNotifier<D> transform<D>({
    required D Function(T sourceValue) transformer,
  }) {
    return TransformableValueNotifier<T, D>(
      source: this,
      transformer: transformer,
    );
  }
}

@Deprecated('Use TransformableValueNotifier<T,D> instead.')
class SelectValueNotifier<T, D> extends TransformableValueNotifier<T, D> {
  SelectValueNotifier({
    required ValueListenable<T> valueListenable,
    required D Function(T value) selector,
  }) : super(source: valueListenable, transformer: selector);
}

@Deprecated('Use TransformableValueNotifier2<A, B, R> instead.')
class SelectValueNotifier2<A, B, R> extends TransformableValueNotifier2<A, B, R> {
  SelectValueNotifier2({
    required ValueListenable<A> valueListenableA,
    required ValueListenable<B> valueListenableB,
    required R Function(A valueA, B valueB) selector,
  }) : super(
          sourceA: valueListenableA,
          sourceB: valueListenableB,
          transformer: selector,
        );
}

@Deprecated('Use TransformableValueNotifier3<A, B, C, R> instead.')
class SelectValueNotifier3<A, B, C, R> extends TransformableValueNotifier3<A, B, C, R> {
  SelectValueNotifier3({
    required ValueListenable<A> valueListenableA,
    required ValueListenable<B> valueListenableB,
    required ValueListenable<C> valueListenableC,
    required R Function(A valueA, B valueB, C valueC) selector,
  }) : super(
          sourceA: valueListenableA,
          sourceB: valueListenableB,
          sourceC: valueListenableC,
          transformer: selector,
        );
}

@Deprecated('Use TransformableValueNotifier4<A, B, C, D, R> instead.')
class SelectValueNotifier4<A, B, C, D, R> extends TransformableValueNotifier4<A, B, C, D, R> {
  SelectValueNotifier4({
    required ValueListenable<A> valueListenableA,
    required ValueListenable<B> valueListenableB,
    required ValueListenable<C> valueListenableC,
    required ValueListenable<D> valueListenableD,
    required R Function(A valueA, B valueB, C valueC, D valueD) selector,
  }) : super(
          sourceA: valueListenableA,
          sourceB: valueListenableB,
          sourceC: valueListenableC,
          sourceD: valueListenableD,
          transformer: selector,
        );
}
