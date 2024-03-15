import 'package:april_flutter_utils/src/shelf/shelf.dart';
import 'package:flutter/widgets.dart';

class InheritedShelf<T extends Lattice> extends InheritedNotifier<LatticeManager<T>> {
  const InheritedShelf({
    super.key,
    required this.manager,
    required super.child,
  });

  final LatticeManager<T> manager;

  @override
  LatticeManager<T> get notifier => manager;
}
