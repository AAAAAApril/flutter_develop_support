import 'package:april_flutter_utils/src/shelf/shelf.dart';
import 'package:flutter/widgets.dart';

import 'lattice_notifier.dart';

class LatticeBuilder<L extends Lattice> extends StatelessWidget {
  const LatticeBuilder({super.key, required this.builder, this.child});

  final Widget Function(BuildContext context, L lattice, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return builder.call(context, Shelf.on<L>(context), child);
  }
}

class Lattice2Builder<LA extends Lattice, LB extends Lattice> extends StatelessWidget {
  const Lattice2Builder({super.key, required this.builder, this.child});

  final Widget Function(BuildContext context, LA latticeA, LB latticeB, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return builder.call(context, Shelf.on<LA>(context), Shelf.on<LB>(context), child);
  }
}

class Lattice3Builder<LA extends Lattice, LB extends Lattice, LC extends Lattice> extends StatelessWidget {
  const Lattice3Builder({super.key, required this.builder, this.child});

  final Widget Function(BuildContext context, LA latticeA, LB latticeB, LC latticeC, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return builder.call(context, Shelf.on<LA>(context), Shelf.on<LB>(context), Shelf.on<LC>(context), child);
  }
}

class LatticeBuilder1<L extends Lattice, A> extends StatelessWidget {
  const LatticeBuilder1({super.key, required this.selector, required this.builder, this.child});

  final A Function(L lattice) selector;
  final Widget Function(BuildContext context, A valueA, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: LatticeNotifier1<L, A>(Shelf.of<L>(context), selector: selector),
      builder: builder,
      child: child,
    );
  }
}

class LatticeBuilder2<L extends Lattice, A, B> extends StatelessWidget {
  const LatticeBuilder2({super.key, required this.selector, required this.builder, this.child});

  final (A, B) Function(L lattice) selector;
  final Widget Function(BuildContext context, A valueA, B valueB, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<(A, B)>(
      valueListenable: LatticeNotifier2<L, A, B>(Shelf.of<L>(context), selector: selector),
      builder: (context, value, child) => builder.call(context, value.$1, value.$2, child),
      child: child,
    );
  }
}

class LatticeBuilder3<L extends Lattice, A, B, C> extends StatelessWidget {
  const LatticeBuilder3({super.key, required this.selector, required this.builder, this.child});

  final (A, B, C) Function(L lattice) selector;
  final Widget Function(BuildContext context, A valueA, B valueB, C valueC, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<(A, B, C)>(
      valueListenable: LatticeNotifier3<L, A, B, C>(Shelf.of<L>(context), selector: selector),
      builder: (context, value, child) => builder.call(context, value.$1, value.$2, value.$3, child),
      child: child,
    );
  }
}

class LatticeBuilder4<L extends Lattice, A, B, C, D> extends StatelessWidget {
  const LatticeBuilder4({super.key, required this.selector, required this.builder, this.child});

  final (A, B, C, D) Function(L lattice) selector;
  final Widget Function(BuildContext context, A valueA, B valueB, C valueC, D valueD, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<(A, B, C, D)>(
      valueListenable: LatticeNotifier4<L, A, B, C, D>(Shelf.of<L>(context), selector: selector),
      builder: (context, value, child) => builder.call(context, value.$1, value.$2, value.$3, value.$4, child),
      child: child,
    );
  }
}
