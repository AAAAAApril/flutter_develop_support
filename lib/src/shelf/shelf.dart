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

  ///创建
  @mustCallSuper
  void create() {
    if (!created) {
      created = true;
      onCreated();
    }
  }

  ///销毁
  @mustCallSuper
  void destroy() {
    if (created) {
      created = false;
      onDestroyed();
    }
    if (!disposed) {
      disposed = true;
      dispose();
    }
  }
}

abstract class LatticeManager<T extends Lattice> extends ChangeNotifier {
  factory LatticeManager(T lattice, {bool autoDisposable = true}) =>
      _InstanceManager<T>(lattice, autoDisposable: autoDisposable);

  factory LatticeManager.lazy({required ValueGetter<T> creator, bool autoDisposable = true}) =>
      _LazyManager<T>(creator: creator, autoDisposable: autoDisposable);

  @protected
  LatticeManager.private();

  String get latticeType => T.toString();

  T get lattice;

  ///是否允许自动释放
  bool get autoDisposable;

  @protected
  void postLatticeCreated(T lattice) {
    lattice.create();
  }

  @protected
  void postLatticeDisposed(T lattice) {
    lattice.destroy();
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
  Map<String, LatticeManager> managers = {};

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
    final Map<String, LatticeManager> oldManagers = Map.of(managers);
    managers = {};
    for (var element in widget.lattices) {
      final String key = element.latticeType;
      managers[key] = oldManagers.remove(key) ?? element;
    }
    oldManagers.forEach((key, value) {
      value.dispose();
    });
  }

  @override
  void dispose() {
    super.dispose();
    managers.forEach((key, value) {
      value.dispose();
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
  _InstanceManager(this._lattice, {required this.autoDisposable}) : super.private() {
    _lattice.addListener(notifyListeners);
  }

  final T _lattice;

  bool _visit = false;

  @override
  T get lattice {
    if (!_visit) {
      _visit = true;
      postLatticeCreated(_lattice);
    }
    return _lattice;
  }

  @override
  final bool autoDisposable;

  @override
  void dispose() {
    _lattice.removeListener(notifyListeners);
    if (autoDisposable) {
      postLatticeDisposed(_lattice);
    }
    super.dispose();
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
  void dispose() {
    _lattice?.removeListener(notifyListeners);
    if (autoDisposable) {
      if (_lattice != null) {
        postLatticeDisposed(_lattice!);
      }
    }
    super.dispose();
  }
}
