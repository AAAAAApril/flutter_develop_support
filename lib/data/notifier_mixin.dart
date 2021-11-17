import 'package:flutter/foundation.dart';

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
