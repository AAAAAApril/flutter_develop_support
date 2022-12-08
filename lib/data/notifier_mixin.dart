import 'package:flutter/foundation.dart';

import 'package:april_flutter_utils/data/value_notifier.dart';

///集中处理各个监听器的销毁，避免每次都手动写一堆无用代码
abstract class ChangeNotifierMixin {
  bool _disposed = false;

  ///需要集中销毁的监听器队列
  final Set<ChangeNotifier> _notifiers = <ChangeNotifier>{};

  void _addNotifier(ChangeNotifier notifier) {
    if (_disposed) return;
    _notifiers.add(notifier);
  }

  void _removeNotifier(ChangeNotifier notifier) {
    _notifiers.remove(notifier);
  }

  @mustCallSuper
  void dispose() {
    _disposed = true;
    _notifiers
      ..forEach((element) => element.dispose())
      ..clear();
  }

  ///这个函数是为了配合 [MixinValueListenableExt.setValue]
  void notifierSetValue<T>(
    ValueListenable<T> listenable,
    T newValue,
  ) {
    listenable.setValue(newValue);
  }
}

extension MixinValueNotifierExt<T extends ChangeNotifier> on T {
  /// 使用此函数把自身添加到队列
  T withMixin(ChangeNotifierMixin notifierMixin) {
    notifierMixin._addNotifier(this);
    return this;
  }

  ///从队列中移除自己
  void escapeMixin(ChangeNotifierMixin notifierMixin) {
    notifierMixin._removeNotifier(this);
  }
}

extension MixinValueListenableExt<T> on ValueListenable<T> {
  ///有时候为了避免外部修改数据，需要只对外暴露 ValueListenable<T>
  ///这样一来就要多写一个 get 函数，为了省事，就可以直接使用这个扩展。
  void setValue(T newValue) {
    if (this is ValueNotifier<T>) {
      (this as ValueNotifier<T>).value = newValue;
    } else if (this is NotifiableValueNotifier<T>) {
      (this as NotifiableValueNotifier<T>).value = newValue;
    }
  }
}
