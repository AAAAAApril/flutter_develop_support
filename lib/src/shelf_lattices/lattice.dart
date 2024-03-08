import 'package:april_flutter_utils/src/shelf_lattices/shelf.dart';
import 'package:flutter/widgets.dart';

class Lattice<T extends ChangeNotifier, A> extends StatefulWidget {
  const Lattice({
    super.key,
    required this.selector,
    this.needRebuild,
    required this.builder,
    this.child,
  });

  final A Function(T shelf) selector;
  final bool Function(A oldA, A newA)? needRebuild;
  final Widget Function(BuildContext context, A valueA, Widget? child) builder;
  final Widget? child;

  @override
  State<Lattice<T, A>> createState() => _LatticeState<T, A>();
}

class _LatticeState<T extends ChangeNotifier, A> extends State<Lattice<T, A>> {
  T? shelf;
  A? valueA;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    shelf?.removeListener(onValueChanged);
    shelf = Shelf.of<T>(context);
    shelf!.addListener(onValueChanged);
    valueA = null;
    onValueChanged();
  }

  @override
  void didUpdateWidget(covariant Lattice<T, A> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selector != widget.selector ||
        (oldWidget.needRebuild != null && widget.needRebuild != null && oldWidget.needRebuild != widget.needRebuild)) {
      onValueChanged();
    }
  }

  @override
  void dispose() {
    super.dispose();
    shelf!.removeListener(onValueChanged);
  }

  void onValueChanged() {
    final A? oldValueA = valueA;
    final A newValueA = widget.selector.call(shelf!);
    if (oldValueA == null || (widget.needRebuild?.call(oldValueA, newValueA) ?? oldValueA != newValueA)) {
      setState(() {
        valueA = newValueA;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, valueA as A, widget.child);
  }
}

class Lattice2<T extends ChangeNotifier, A, B> extends StatefulWidget {
  const Lattice2({
    super.key,
    required this.selector,
    this.needRebuild,
    required this.builder,
    this.child,
  });

  final (A valueA, B valueB) Function(T shelf) selector;
  final bool Function(A oldA, A newA, B oldB, B newB)? needRebuild;
  final Widget Function(BuildContext context, A valueA, B valueB, Widget? child) builder;
  final Widget? child;

  @override
  State<Lattice2<T, A, B>> createState() => _Lattice2State<T, A, B>();
}

class _Lattice2State<T extends ChangeNotifier, A, B> extends State<Lattice2<T, A, B>> {
  T? shelf;
  A? valueA;
  B? valueB;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    shelf?.removeListener(onValueChanged);
    shelf = Shelf.of<T>(context);
    shelf!.addListener(onValueChanged);
    valueA = null;
    valueB = null;
    onValueChanged();
  }

  @override
  void didUpdateWidget(covariant Lattice2<T, A, B> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selector != widget.selector ||
        (oldWidget.needRebuild != null && widget.needRebuild != null && oldWidget.needRebuild != widget.needRebuild)) {
      onValueChanged();
    }
  }

  @override
  void dispose() {
    super.dispose();
    shelf!.removeListener(onValueChanged);
  }

  void onValueChanged() {
    final A? oldValueA = valueA;
    final B? oldValueB = valueB;
    final (A newValueA, B newValueB) = widget.selector.call(shelf!);
    if (oldValueA == null ||
        oldValueB == null ||
        (widget.needRebuild?.call(oldValueA, newValueA, oldValueB, newValueB) ??
            (oldValueA != newValueA || oldValueB != newValueB))) {
      setState(() {
        valueA = newValueA;
        valueB = newValueB;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, valueA as A, valueB as B, widget.child);
  }
}

class Lattice3<T extends ChangeNotifier, A, B, C> extends StatefulWidget {
  const Lattice3({
    super.key,
    required this.selector,
    this.needRebuild,
    required this.builder,
    this.child,
  });

  final (A valueA, B valueB, C valueC) Function(T shelf) selector;
  final bool Function(A oldA, A newA, B oldB, B newB, C oldC, C newC)? needRebuild;
  final Widget Function(BuildContext context, A valueA, B valueB, C valueC, Widget? child) builder;
  final Widget? child;

  @override
  State<Lattice3<T, A, B, C>> createState() => _Lattice3State<T, A, B, C>();
}

class _Lattice3State<T extends ChangeNotifier, A, B, C> extends State<Lattice3<T, A, B, C>> {
  T? shelf;
  A? valueA;
  B? valueB;
  C? valueC;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    shelf?.removeListener(onValueChanged);
    shelf = Shelf.of<T>(context);
    shelf!.addListener(onValueChanged);
    valueA = null;
    valueB = null;
    valueC = null;
    onValueChanged();
  }

  @override
  void didUpdateWidget(covariant Lattice3<T, A, B, C> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selector != widget.selector ||
        (oldWidget.needRebuild != null && widget.needRebuild != null && oldWidget.needRebuild != widget.needRebuild)) {
      onValueChanged();
    }
  }

  @override
  void dispose() {
    super.dispose();
    shelf!.removeListener(onValueChanged);
  }

  void onValueChanged() {
    final A? oldValueA = valueA;
    final B? oldValueB = valueB;
    final C? oldValueC = valueC;
    final (A newValueA, B newValueB, C newValueC) = widget.selector.call(shelf!);
    if (oldValueA == null ||
        oldValueB == null ||
        oldValueC == null ||
        (widget.needRebuild?.call(oldValueA, newValueA, oldValueB, newValueB, oldValueC, newValueC) ??
            (oldValueA != newValueA || oldValueB != newValueB || oldValueC != newValueC))) {
      setState(() {
        valueA = newValueA;
        valueB = newValueB;
        valueC = newValueC;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, valueA as A, valueB as B, valueC as C, widget.child);
  }
}

class Lattice0<T extends ChangeNotifier> extends StatelessWidget {
  const Lattice0({
    super.key,
    required this.builder,
    this.child,
  });

  final Widget Function(BuildContext context, T shelf, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return builder.call(context, Shelf.on<T>(context), child);
  }
}
