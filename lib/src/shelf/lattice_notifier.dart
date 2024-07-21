import 'package:april_flutter_utils/src/shelf/shelf.dart';
import 'package:flutter/foundation.dart';

class LatticeNotifier<A extends Lattice, T> extends ValueNotifier<T> {
  LatticeNotifier(
    this.lattice, {
    required this.selector,
  }) : super(selector.call(lattice)) {
    lattice.addListener(onLatticeChanged);
  }

  final A lattice;
  final T Function(A lattice) selector;

  void onLatticeChanged() {
    value = selector.call(lattice);
  }

  @override
  void dispose() {
    lattice.removeListener(onLatticeChanged);
    super.dispose();
  }
}

class Lattice2Notifier<A extends Lattice, B extends Lattice, T> extends ValueNotifier<T> {
  Lattice2Notifier(
    this.latticeA,
    this.latticeB, {
    required this.selector,
  }) : super(selector.call(latticeA, latticeB)) {
    latticeA.addListener(onLatticeChanged);
    latticeB.addListener(onLatticeChanged);
  }

  final A latticeA;
  final B latticeB;
  final T Function(A latticeA, B latticeB) selector;

  void onLatticeChanged() {
    value = selector.call(latticeA, latticeB);
  }

  @override
  void dispose() {
    latticeB.removeListener(onLatticeChanged);
    latticeA.removeListener(onLatticeChanged);
    super.dispose();
  }
}

class Lattice3Notifier<A extends Lattice, B extends Lattice, C extends Lattice, T> extends ValueNotifier<T> {
  Lattice3Notifier(
    this.latticeA,
    this.latticeB,
    this.latticeC, {
    required this.selector,
  }) : super(selector.call(latticeA, latticeB, latticeC)) {
    latticeA.addListener(onLatticeChanged);
    latticeB.addListener(onLatticeChanged);
    latticeC.addListener(onLatticeChanged);
  }

  final A latticeA;
  final B latticeB;
  final C latticeC;
  final T Function(A latticeA, B latticeB, C latticeC) selector;

  void onLatticeChanged() {
    value = selector.call(latticeA, latticeB, latticeC);
  }

  @override
  void dispose() {
    latticeC.removeListener(onLatticeChanged);
    latticeB.removeListener(onLatticeChanged);
    latticeA.removeListener(onLatticeChanged);
    super.dispose();
  }
}
