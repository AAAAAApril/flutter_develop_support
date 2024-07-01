import 'package:flutter/widgets.dart';

import 'inherited_shelf.dart';

class Shelf extends StatefulWidget {
  static T? maybeOf<T extends Lattice>(BuildContext context) {
    return context.getInheritedWidgetOfExactType<InheritedShelf<T>>()?.manager.lattice;
  }

  static T? maybeOn<T extends Lattice>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedShelf<T>>()?.manager.lattice;
  }

  static T of<T extends Lattice>(BuildContext context) {
    final T? result = maybeOf<T>(context);
    assert(result != null, 'No lattice typed $T found in context.');
    return result!;
  }

  static T on<T extends Lattice>(BuildContext context) {
    final T? result = maybeOn<T>(context);
    assert(result != null, 'No lattice typed $T found in context.');
    return result!;
  }

  const Shelf({
    super.key,
    required this.lattices,
    required this.child,
  });

  final Set<LatticeManager> lattices;
  final Widget child;

  @override
  State<Shelf> createState() => _ShelfState();
}

abstract class Lattice extends ChangeNotifier {
  Lattice();

  ///创建完成
  @protected
  void onCreated();

  ///销毁完成
  @protected
  void onDestroyed();

  ///是否已被创建
  bool _created = false;

  bool get created => _created;

  @protected
  set created(bool value) => _created = value;

  ///是否已被释放
  bool _disposed = false;

  bool get disposed => _disposed;

  @protected
  set disposed(bool value) => _disposed = value;
}

abstract class LatticeManager<T extends Lattice> extends ChangeNotifier {
  factory LatticeManager(T lattice, {bool autoDisposable = true}) =>
      _InstanceManager<T>(lattice, autoDisposable: autoDisposable);

  factory LatticeManager.lazy({required ValueGetter<T> creator, bool autoDisposable = true}) =>
      _LazyManager<T>(creator: creator, autoDisposable: autoDisposable);

  @protected
  LatticeManager.private();

  Type get latticeType => T;

  T get lattice;

  ///是否允许自动释放
  bool get autoDisposable;

  ///自动释放
  void autoDispose() {
    if (autoDisposable) {
      dispose();
    }
  }

  @protected
  void postLatticeCreated(T lattice) {
    if (!lattice.created) {
      lattice.created = true;
      lattice.onCreated();
    }
  }

  @protected
  void postLatticeDisposed(T lattice) {
    if (lattice.created) {
      lattice.created = false;
      lattice.onDestroyed();
    }
    if (!lattice.disposed) {
      lattice.disposed = true;
      lattice.dispose();
    }
  }

  @protected
  Widget inheritedWidget(Widget child) {
    return InheritedShelf<T>(
      key: ValueKey(latticeType),
      manager: this,
      child: child,
    );
  }
}

class _ShelfState extends State<Shelf> {
  Map<Type, LatticeManager> managers = {};

  @override
  void initState() {
    super.initState();
    for (var element in widget.lattices) {
      managers[element.latticeType] = element;
    }
  }

  @override
  void didUpdateWidget(covariant Shelf oldWidget) {
    super.didUpdateWidget(oldWidget);
    final Map<Type, LatticeManager> oldManagers = Map.of(managers);
    managers = {};
    for (var element in widget.lattices) {
      final Type key = element.latticeType;
      managers[key] = oldManagers.remove(key) ?? element;
    }
    oldManagers.forEach((key, value) {
      value.autoDispose();
    });
  }

  @override
  void dispose() {
    super.dispose();
    managers.forEach((key, value) {
      value.autoDispose();
    });
    managers = {};
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;
    managers.values.toList().reversed.forEach((element) {
      child = element.inheritedWidget(child);
    });
    return child;
  }
}

class _InstanceManager<T extends Lattice> extends LatticeManager<T> {
  _InstanceManager(this.lattice, {required this.autoDisposable}) : super.private() {
    lattice.addListener(notifyListeners);
    postLatticeCreated(lattice);
  }

  @override
  final T lattice;

  @override
  final bool autoDisposable;

  @override
  void autoDispose() {
    lattice.removeListener(notifyListeners);
    if (autoDisposable) {
      postLatticeDisposed(lattice);
    }
    super.autoDispose();
  }
}

class _LazyManager<T extends Lattice> extends LatticeManager<T> {
  _LazyManager({required this.creator, required this.autoDisposable}) : super.private();

  final ValueGetter<T> creator;

  T? _lattice;

  @override
  T get lattice {
    if (_lattice == null) {
      _lattice = creator.call();
      _lattice!.addListener(notifyListeners);
      postLatticeCreated(_lattice!);
    }
    return _lattice!;
  }

  @override
  final bool autoDisposable;

  @override
  void autoDispose() {
    _lattice?.removeListener(notifyListeners);
    if (autoDisposable) {
      if (_lattice != null) {
        postLatticeDisposed(_lattice!);
      }
    }
    super.autoDispose();
  }
}
