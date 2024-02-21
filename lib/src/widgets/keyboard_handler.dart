import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class KeyboardHandlerScope extends StatefulWidget {
  const KeyboardHandlerScope({
    super.key,
    this.whetherInterceptEvent,
    required this.child,
  });

  final Widget child;

  final bool Function(KeyEvent event)? whetherInterceptEvent;

  @override
  State<KeyboardHandlerScope> createState() => _KeyboardHandlerScopeState();
}

class _KeyboardHandlerScopeState extends State<KeyboardHandlerScope> {
  final KeyboardHandler handler = KeyboardHandler();

  @override
  void dispose() {
    super.dispose();
    ServicesBinding.instance.keyboard.removeHandler(onKeyboardHandled);
  }

  void onEnter(PointerEnterEvent event) {
    ServicesBinding.instance.keyboard.addHandler(onKeyboardHandled);
  }

  void onExit(PointerExitEvent event) {
    ServicesBinding.instance.keyboard.removeHandler(onKeyboardHandled);
  }

  bool onKeyboardHandled(KeyEvent event) {
    if (!handler._onKeyHandled(event)) {
      return false;
    }
    if (widget.whetherInterceptEvent?.call(event) != false) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: onEnter,
      onExit: onExit,
      child: InheritedKeyboardHandler(
        handler,
        child: widget.child,
      ),
    );
  }
}

class KeyboardHandlerClient extends StatelessWidget {
  const KeyboardHandlerClient({
    super.key,
    required this.handler,
    required this.child,
  });

  final KeyboardHandler handler;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        KeyboardHandler.parent(context).addChild(handler);
      },
      onExit: (event) {
        KeyboardHandler.parent(context).removeChild(handler);
      },
      child: child,
    );
  }
}

class KeyboardHandlerWidget extends StatefulWidget {
  const KeyboardHandlerWidget({
    super.key,
    required this.onHandlerCreated,
    required this.child,
  });

  final Widget child;

  final void Function(KeyboardHandler handler) onHandlerCreated;

  @override
  State<KeyboardHandlerWidget> createState() => _KeyboardHandlerWidgetState();
}

class _KeyboardHandlerWidgetState extends State<KeyboardHandlerWidget> {
  KeyboardHandler? parent;
  late KeyboardHandler handler;

  @override
  void initState() {
    super.initState();
    handler = KeyboardHandler();
    widget.onHandlerCreated.call(handler);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newParent = KeyboardHandler.parent(context);
    if (newParent != parent) {
      if (parent != null && parent!.containsChild(handler)) {
        parent!.removeChild(handler);
        newParent.addChild(handler);
      }
    }
    parent = newParent;
  }

  @override
  void dispose() {
    super.dispose();
    parent?.removeChild(handler);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardHandlerClient(handler: handler, child: widget.child);
  }
}

///@return [bool] intercept or not
typedef KeyboardHandlerCallback = bool Function(KeyEvent event);

class KeyboardHandler {
  static KeyboardHandler parent(BuildContext context) {
    final result = InheritedKeyboardHandler.maybeOf(context);
    assert(result != null, 'No parent KeyboardHandler found in context.');
    return result!;
  }

  KeyboardHandler();

  ///关注的键
  final Map<LogicalKeyboardKey, KeyboardHandlerCallback> _focusedKeys = {};

  void focusKey(LogicalKeyboardKey key, KeyboardHandlerCallback callback) {
    _focusedKeys[key] = callback;
  }

  void focusKeys(Set<LogicalKeyboardKey> keys, KeyboardHandlerCallback callback) {
    for (var element in keys) {
      focusKey(element, callback);
    }
  }

  void undoFocusKeys(Set<LogicalKeyboardKey> keys) {
    _focusedKeys.removeWhere((key, value) => keys.contains(key));
  }

  void undoFocusAllKeys() {
    _focusedKeys.clear();
  }

  ///要排除的键
  final Set<LogicalKeyboardKey> _excludedKeys = {};

  void excludeKeys(Set<LogicalKeyboardKey> keys) {
    _excludedKeys.addAll(keys);
  }

  void undoExcludeKeys(Set<LogicalKeyboardKey> keys) {
    _excludedKeys.removeAll(keys);
  }

  void undoExcludeAllKeys() {
    _excludedKeys.clear();
  }

  ///接收所有，但是 [_excludedKeys] 除外
  KeyboardHandlerCallback? _onHandleAll;

  void handleAll(KeyboardHandlerCallback callback) {
    _onHandleAll = callback;
  }

  void undoHandleAll() {
    _onHandleAll = null;
  }

  ///子级
  final Set<KeyboardHandler> _children = {};

  void addChild(KeyboardHandler child) {
    _children.add(child);
  }

  void removeChild(KeyboardHandler child) {
    _children.remove(child);
  }

  bool containsChild(KeyboardHandler child) => _children.contains(child);

  ///收到了键盘事件
  bool _onKeyHandled(KeyEvent event) {
    for (var element in List.of(_children).reversed) {
      if (element._onKeyHandled(event)) {
        return true;
      }
    }
    if (_excludedKeys.contains(event.logicalKey)) {
      return false;
    }
    final KeyboardHandlerCallback? callback = _onHandleAll ?? _focusedKeys[event.logicalKey];
    if (callback == null) {
      return false;
    }
    return callback.call(event);
  }
}

class InheritedKeyboardHandler extends InheritedWidget {
  static KeyboardHandler? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<InheritedKeyboardHandler>()?.handler;
  }

  const InheritedKeyboardHandler(this.handler, {super.key, required super.child});

  final KeyboardHandler handler;

  @override
  bool updateShouldNotify(covariant InheritedKeyboardHandler oldWidget) {
    return handler != oldWidget.handler;
  }
}
