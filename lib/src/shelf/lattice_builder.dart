import 'package:april_flutter_utils/src/shelf/shelf.dart';
import 'package:flutter/widgets.dart';

class LatticeSelector<L extends Lattice, T> extends StatelessWidget {
  const LatticeSelector({
    super.key,
    required this.selector,
    required this.shouldNotify,
    required this.builder,
    this.child,
  });

  final T Function(L lattice) selector;
  final ValueWidgetBuilder<T> builder;
  final bool Function(T newData, T? data)? shouldNotify;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    Widget? cache;
    T? data;
    return Builder(builder: (context) {
      final lattice = Shelf.on<L>(context);
      final T newData = selector.call(lattice);
      if (cache == null || (shouldNotify?.call(newData, data) ?? (newData != data))) {
        data = newData;
        cache = builder.call(context, newData, child);
      }
      return cache!;
    });
  }
}

class Lattice2Selector<A extends Lattice, B extends Lattice, T> extends StatelessWidget {
  const Lattice2Selector({
    super.key,
    required this.selector,
    required this.shouldNotify,
    required this.builder,
    this.child,
  });

  final T Function(A latticeA, B latticeB) selector;
  final bool Function(T newData, T? data)? shouldNotify;
  final ValueWidgetBuilder<T> builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    Widget? cache;
    T? data;
    return Builder(builder: (context) {
      final latticeA = Shelf.on<A>(context);
      final latticeB = Shelf.on<B>(context);
      final T newData = selector.call(latticeA, latticeB);
      if (cache == null || (shouldNotify?.call(newData, data) ?? (newData != data))) {
        data = newData;
        cache = builder.call(context, newData, child);
      }
      return cache!;
    });
  }
}

class Lattice3Selector<A extends Lattice, B extends Lattice, C extends Lattice, T> extends StatelessWidget {
  const Lattice3Selector({
    super.key,
    required this.selector,
    required this.shouldNotify,
    required this.builder,
    this.child,
  });

  final T Function(A latticeA, B latticeB, C latticeC) selector;
  final bool Function(T newData, T? data)? shouldNotify;
  final ValueWidgetBuilder<T> builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    Widget? cache;
    T? data;
    return Builder(builder: (context) {
      final latticeA = Shelf.on<A>(context);
      final latticeB = Shelf.on<B>(context);
      final latticeC = Shelf.on<C>(context);
      final T newData = selector.call(latticeA, latticeB, latticeC);
      if (cache == null || (shouldNotify?.call(newData, data) ?? (newData != data))) {
        data = newData;
        cache = builder.call(context, newData, child);
      }
      return cache!;
    });
  }
}
