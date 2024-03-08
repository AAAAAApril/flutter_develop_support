import 'package:flutter/widgets.dart';

class Shelf<T extends ChangeNotifier> extends StatelessWidget {
  static T? maybeOf<T extends ChangeNotifier>(BuildContext context) {
    return context.getInheritedWidgetOfExactType<ShelfInheritedNotifier<T>>()?.notifier;
  }

  static T of<T extends ChangeNotifier>(BuildContext context) {
    final T? result = maybeOf<T>(context);
    assert(result != null, 'No Shelf<$T> found in context.');
    return result!;
  }

  static T? maybeOn<T extends ChangeNotifier>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShelfInheritedNotifier<T>>()?.notifier;
  }

  static T on<T extends ChangeNotifier>(BuildContext context) {
    final T? result = maybeOn<T>(context);
    assert(result != null, 'No Shelf<$T> found in context.');
    return result!;
  }

  Shelf({
    super.key,
    required T shelf,
    bool autoDispose = true,
    required this.child,
  }) : creator = ShelfCreator<T>(shelf, autoDispose: autoDispose);

  Shelf.lazy({
    super.key,
    required ValueGetter<T> creator,
    bool autoDispose = true,
    required this.child,
  }) : creator = ShelfCreator<T>.lazy(creator: creator, autoDispose: autoDispose);

  final ShelfCreator<T> creator;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shelves(shelves: [creator], child: child);
  }
}

class Shelves extends StatefulWidget {
  const Shelves({
    super.key,
    required this.shelves,
    required this.child,
  });

  final List<ShelfCreator> shelves;
  final Widget child;

  @override
  State<Shelves> createState() => _ShelvesState();
}

class _ShelvesState extends State<Shelves> {
  @override
  void dispose() {
    super.dispose();
    for (var element in widget.shelves) {
      element.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;
    for (var element in widget.shelves) {
      child = ShelfInheritedNotifier.private(
        creator: element,
        child: child,
      );
    }
    return child;
  }
}

class ShelfInheritedNotifier<T extends ChangeNotifier> extends InheritedNotifier<T> {
  @protected
  const ShelfInheritedNotifier.private({
    super.key,
    required ShelfCreator<T> creator,
    required super.child,
  }) : _creator = creator;

  final ShelfCreator<T> _creator;

  @override
  T get notifier => _creator.value;
}

abstract class ShelfCreator<T extends ChangeNotifier> {
  factory ShelfCreator(T shelf, {bool autoDispose = true}) => _Def<T>(shelf, autoDispose);

  factory ShelfCreator.lazy({
    required ValueGetter<T> creator,
    bool autoDispose = true,
  }) =>
      _Lazy(creator: creator, autoDispose: autoDispose);

  @protected
  const ShelfCreator.private();

  T get value;

  bool get autoDispose;

  void dispose();
}

class _Def<T extends ChangeNotifier> extends ShelfCreator<T> {
  const _Def(this.value, this.autoDispose) : super.private();

  @override
  final T value;

  @override
  final bool autoDispose;

  @override
  void dispose() {
    if (autoDispose) {
      value.dispose();
    }
  }
}

class _Lazy<T extends ChangeNotifier> extends ShelfCreator<T> {
  _Lazy({required this.creator, required this.autoDispose}) : super.private();

  final T Function() creator;

  T? _value;

  @override
  T get value => _value ??= creator.call();

  @override
  final bool autoDispose;

  @override
  void dispose() {
    if (_value != null && autoDispose) {
      _value?.dispose();
    }
  }
}
