import 'package:april_flutter_utils/src/shelf/shelf.dart';
import 'package:flutter/foundation.dart';

class LatticeNotifier<L extends Lattice> extends ChangeNotifier implements ValueListenable<L> {
  LatticeNotifier(L lattice) : _lattice = lattice {
    _lattice.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _lattice.removeListener(notifyListeners);
    super.dispose();
  }

  final L _lattice;

  @override
  L get value => _lattice;

  @override
  String toString() => '${describeIdentity(this)}($value)';
}

class LatticeNotifier1<L extends Lattice, A> extends ValueNotifier<A> {
  LatticeNotifier1(
    this.lattice, {
    required this.selector,
  }) : super(selector.call(lattice)) {
    lattice.addListener(onLatticeChanged);
  }

  final L lattice;
  final A Function(L lattice) selector;

  void onLatticeChanged() {
    value = selector.call(lattice);
  }

  @override
  void dispose() {
    lattice.removeListener(onLatticeChanged);
    super.dispose();
  }
}

class LatticeNotifier2<L extends Lattice, A, B> extends ValueNotifier<(A, B)> {
  LatticeNotifier2(
    this.lattice, {
    required this.selector,
  }) : super(selector.call(lattice)) {
    lattice.addListener(onLatticeChanged);
  }

  final L lattice;
  final (A, B) Function(L lattice) selector;

  void onLatticeChanged() {
    final newValue = selector.call(lattice);
    if (newValue.$1 == value.$1 && newValue.$2 == value.$2) {
      return;
    }
    value = newValue;
  }

  @override
  void dispose() {
    lattice.removeListener(onLatticeChanged);
    super.dispose();
  }
}

class LatticeNotifier3<L extends Lattice, A, B, C> extends ValueNotifier<(A, B, C)> {
  LatticeNotifier3(
    this.lattice, {
    required this.selector,
  }) : super(selector.call(lattice)) {
    lattice.addListener(onLatticeChanged);
  }

  final L lattice;
  final (A, B, C) Function(L lattice) selector;

  void onLatticeChanged() {
    final newValue = selector.call(lattice);
    if (newValue.$1 == value.$1 && newValue.$2 == value.$2 && newValue.$3 == value.$3) {
      return;
    }
    value = newValue;
  }

  @override
  void dispose() {
    lattice.removeListener(onLatticeChanged);
    super.dispose();
  }
}

class LatticeNotifier4<L extends Lattice, A, B, C, D> extends ValueNotifier<(A, B, C, D)> {
  LatticeNotifier4(
    this.lattice, {
    required this.selector,
  }) : super(selector.call(lattice)) {
    lattice.addListener(onLatticeChanged);
  }

  final L lattice;
  final (A, B, C, D) Function(L lattice) selector;

  void onLatticeChanged() {
    final newValue = selector.call(lattice);
    if (newValue.$1 == value.$1 && newValue.$2 == value.$2 && newValue.$3 == value.$3 && newValue.$4 == value.$4) {
      return;
    }
    value = newValue;
  }

  @override
  void dispose() {
    lattice.removeListener(onLatticeChanged);
    super.dispose();
  }
}

class LatticeNotifier5<L extends Lattice, A, B, C, D, E> extends ValueNotifier<(A, B, C, D, E)> {
  LatticeNotifier5(
    this.lattice, {
    required this.selector,
  }) : super(selector.call(lattice)) {
    lattice.addListener(onLatticeChanged);
  }

  final L lattice;
  final (A, B, C, D, E) Function(L lattice) selector;

  void onLatticeChanged() {
    final newValue = selector.call(lattice);
    if (newValue.$1 == value.$1 &&
        newValue.$2 == value.$2 &&
        newValue.$3 == value.$3 &&
        newValue.$4 == value.$4 &&
        newValue.$5 == value.$5) {
      return;
    }
    value = newValue;
  }

  @override
  void dispose() {
    lattice.removeListener(onLatticeChanged);
    super.dispose();
  }
}
