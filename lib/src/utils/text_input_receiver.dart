import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

///在桌面端，没有输入框时，接收来自键盘输入的内容
class TextInputReceiver {
  static FocusNode createFocusNode() => TextFieldFocusNode();

  static ValueListenable<TextEditingValue> get editingValue => _InputClient.instance.editingValue;

  static void start() {
    TextInputReceiver._instance._start();
  }

  static void stop() {
    TextInputReceiver._instance._stop();
  }

  static void clearCache() {
    TextInputReceiver._instance._clearCache();
  }

  static final TextInputReceiver _instance = TextInputReceiver._();

  TextInputReceiver._();

  ///是否允许接收
  bool _enable = false;

  ///编辑框是否有焦点
  bool _fieldFocused = false;

  TextInputConnection? _inputConnection;

  bool get _hasConnection => _inputConnection != null;

  ///开始接收
  void _start() {
    _enable = true;
    _clearCache();
    _onFocusNodeChanged();
  }

  ///停止接收
  void _stop() {
    _enable = false;
    _clearCache();
    _onFocusNodeChanged();
  }

  ///清除输入缓存
  void _clearCache() {
    _InputClient.instance.clearValue();
  }

  Timer? _delayTimer;

  void _onFocusNodeChanged() {
    _delayTimer?.cancel();
    _delayTimer = Timer(Duration.zero, _delayed);
  }

  void _delayed() {
    _fieldFocused = TextFieldFocusNode._fieldsNodes.any(
      (element) => element.hasFocus,
    );
    if (!_fieldFocused && _enable) {
      if (!_hasConnection) {
        _inputConnection = TextInput.attach(
          _InputClient.instance,
          const TextInputConfiguration(inputAction: TextInputAction.none),
        );
        _inputConnection?.show();
      }
    } else {
      _inputConnection?.close();
      _inputConnection = null;
    }
  }
}

class TextFieldFocusNode extends FocusNode {
  static final Set<FocusNode> _fieldsNodes = <FocusNode>{};

  TextFieldFocusNode({
    super.debugLabel,
    super.canRequestFocus,
    super.descendantsAreFocusable,
    super.descendantsAreTraversable,
    super.onKeyEvent,
    super.skipTraversal,
  }) {
    TextFieldFocusNode._fieldsNodes.add(this);
    addListener(TextInputReceiver._instance._onFocusNodeChanged);
  }

  @override
  void dispose() {
    super.dispose();
    TextFieldFocusNode._fieldsNodes.remove(this);
    TextInputReceiver._instance._onFocusNodeChanged.call();
  }
}

class _InputClient with TextInputClient {
  static final _InputClient instance = _InputClient._();

  _InputClient._();

  final ValueNotifier<TextEditingValue> editingValue = ValueNotifier(TextEditingValue.empty);

  ///清空输入内容
  void clearValue() {
    editingValue.value = TextEditingValue.empty;
  }

  @override
  void connectionClosed() {
    clearValue();
    TextInputReceiver._instance._inputConnection?.connectionClosedReceived();
    TextInputReceiver._instance._inputConnection = null;
  }

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  TextEditingValue get currentTextEditingValue => editingValue.value;

  @override
  void performAction(TextInputAction action) {}

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {}

  @override
  void showAutocorrectionPromptRect(int start, int end) {}

  @override
  void updateEditingValue(TextEditingValue value) {
    editingValue.value = value;
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {}
}
