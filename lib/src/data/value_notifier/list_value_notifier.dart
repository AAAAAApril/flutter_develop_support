import 'dart:math';

import 'package:flutter/foundation.dart';

///存储 [List] 的 [ValueNotifier]
class ListValueNotifier<E> extends ValueNotifier<List<E>> {
  ListValueNotifier([List<E>? value]) : super(value ?? <E>[]);

  List<R> cast<R>() => value.cast<R>();

  E operator [](int index) => value[index];

  void operator []=(int index, E value) => this.value = List<E>.of(this.value)..[index] = value;

  set first(E value) => this.value = List<E>.of(this.value)..first = value;

  set last(E value) => this.value = List<E>.of(this.value)..last = value;

  int get length => value.length;

  void add(E value) => this.value = List<E>.of(this.value)..add(value);

  void addAll(Iterable<E> iterable) {
    if (iterable.isEmpty) {
      return;
    }
    value = List<E>.of(value)..addAll(iterable);
  }

  void reverse() => value = value.reversed.toList();

  void sort(int Function(E a, E b) compare) => value = List<E>.of(value)..sort(compare);

  void shuffle([Random? random]) => value = List<E>.of(value)..shuffle(random);

  int indexOf(E element, [int start = 0]) => value.indexOf(element, start);

  int indexWhere(bool Function(E element) test, [int start = 0]) => value.indexWhere(test, start);

  int lastIndexWhere(bool Function(E element) test, [int? start]) => value.lastIndexWhere(test, start);

  int lastIndexOf(E element, [int? start]) => value.lastIndexOf(element, start);

  void clear() => value = <E>[];

  void insert(int index, E element) => value = List<E>.of(value)..insert(index, element);

  void insertAll(int index, Iterable<E> iterable) {
    if (iterable.isEmpty) {
      return;
    }
    value = List<E>.of(value)..insertAll(index, iterable);
  }

  void setAll(int index, Iterable<E> iterable) {
    if (iterable.isEmpty) {
      return;
    }
    value = List<E>.of(value)..setAll(index, iterable);
  }

  bool remove(Object? value) {
    final bool result = this.value.remove(value);
    if (result) {
      this.value = List<E>.of(this.value);
    }
    return result;
  }

  E removeAt(int index) {
    final E result = value.removeAt(index);
    value = List.of(value);
    return result;
  }

  E removeLast() {
    final E last = value.removeLast();
    value = List<E>.of(value);
    return last;
  }

  void removeWhere(bool Function(E element) test) {
    final int oldLength = value.length;
    value.removeWhere(test);
    if (value.length != oldLength) {
      value = List<E>.of(value);
    }
  }

  void retainWhere(bool Function(E element) test) {
    final int oldLength = value.length;
    value.retainWhere(test);
    if (value.length != oldLength) {
      value = List<E>.of(value);
    }
  }

  List<E> operator +(List<E> other) => value + other;

  List<E> sublist(int start, [int? end]) => value.sublist(start, end);

  Iterable<E> getRange(int start, int end) => value.getRange(start, end);

  void setRange(
    int start,
    int end,
    Iterable<E> iterable, [
    int skipCount = 0,
  ]) {
    if (iterable.isEmpty) {
      return;
    }
    value = List<E>.of(value)
      ..setRange(
        start,
        end,
        iterable,
        skipCount,
      );
  }

  void removeRange(int start, int end) => value = List<E>.of(value)..removeRange(start, end);

  void fillRange(
    int start,
    int end, [
    E? fillValue,
  ]) =>
      value = List<E>.of(value)
        ..fillRange(
          start,
          end,
          fillValue,
        );

  void replaceRange(
    int start,
    int end,
    Iterable<E> replacements,
  ) =>
      value = List<E>.of(value)
        ..replaceRange(
          start,
          end,
          replacements,
        );

  Map<int, E> asMap() => value.asMap();
}
