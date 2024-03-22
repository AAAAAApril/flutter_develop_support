import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

///在桌面端，没有输入框时，接收来自键盘输入的内容
final class TextInputReceiver {
  static final TextInputReceiver instance = TextInputReceiver._();

  static FocusNode createDisableScopeFocusNode() => InputReceiveDisabledScopeNode();

  TextInputReceiver._() {
    _inputClient = _InputClient(
      editingValue: _editingValue,
      onConnectionClosed: _onConnectionClosed,
    );
  }

  ///正在编辑的内容
  final ValueNotifier<TextEditingValue> _editingValue = ValueNotifier(TextEditingValue.empty);

  ValueListenable<TextEditingValue> get editingValue => _editingValue;

  ///支持禁用输入内容接收器的范围
  final Set<InputReceiveDisabledScope> _disabledNodes = <InputReceiveDisabledScope>{};

  ///是否允许接收
  bool _enable = false;

  ///接收器是否已被禁用
  bool get receiverDisabled => _disabledNodes.any((element) => element.disableTextInputReceiver) || !_enable;

  TextInputConnection? _inputConnection;

  TextInputConnection? get _connectionInternal {
    if (_inputConnection?.attached == true) {
      return _inputConnection;
    }
    return null;
  }

  ///是否已连接
  bool get hasConnection => _inputConnection != null;

  late final TextInputClient _inputClient;

  ///开始接收
  void start() {
    _enable = true;
    clearInputCache();
    _autoShowOrClose();
  }

  ///停止接收
  void stop() {
    _enable = false;
    clearInputCache();
    _autoShowOrClose();
  }

  ///清空输入内容
  void clearInputCache() {
    _editingValue.value = TextEditingValue.empty;
    _connectionInternal?.setEditingState(_editingValue.value);
  }

  ///显示输入法
  void showTextInput() {
    _connectionInternal?.show();
  }

  ///更新编辑区域大小
  void updateEditableBoxSize(Size editableBoxSize, Matrix4 transform) {
    _inputConnection
      ?..setEditableSizeAndTransform(editableBoxSize, transform)
      ..setComposingRect(Rect.zero)
      ..setCaretRect(Rect.zero);
  }

  ///将目标 context 的大小设置为编辑区域的大小
  void updateEditableBox(BuildContext editableBoxContext) {
    try {
      final renderEditable = editableBoxContext.findRenderObject()! as RenderBox;
      updateEditableBoxSize(renderEditable.size, renderEditable.getTransformTo(null));
    } catch (_) {
      //ignore
    }
  }

  ///添加禁用范围
  void addDisableScope(InputReceiveDisabledScope node) {
    if (_disabledNodes.contains(node)) {
      return;
    }
    _disabledNodes.add(node);
    node.addListener(_autoShowOrClose);
    _autoShowOrClose();
  }

  ///移除禁用范围
  void removeDisableScope(InputReceiveDisabledScope node) {
    if (!_disabledNodes.contains(node)) {
      return;
    }
    node.removeListener(_autoShowOrClose);
    _disabledNodes.remove(node);
    _autoShowOrClose();
  }

  ///连接已关闭
  void _onConnectionClosed() {
    clearInputCache();
    _inputConnection?.connectionClosedReceived();
    _inputConnection = null;
  }

  Timer? _delayTimer;

  void _autoShowOrClose() {
    _delayTimer?.cancel();
    _delayTimer = Timer(Duration.zero, () {
      if (!receiverDisabled) {
        if (!hasConnection) {
          _inputConnection = TextInput.attach(
            _inputClient,
            const TextInputConfiguration(inputAction: TextInputAction.none, readOnly: true),
          );
        }
        showTextInput();
      } else {
        _inputConnection?.close();
        _inputConnection = null;
      }
    });
  }
}

mixin InputReceiveDisabledScope on Listenable {
  ///是否禁止接收输入内容
  bool get disableTextInputReceiver;
}

class InputReceiveDisabledScopeNode extends FocusNode with InputReceiveDisabledScope {
  InputReceiveDisabledScopeNode({
    super.debugLabel,
    super.canRequestFocus,
    super.descendantsAreFocusable,
    super.descendantsAreTraversable,
    super.onKeyEvent,
    super.skipTraversal,
  }) {
    TextInputReceiver.instance.addDisableScope(this);
  }

  @override
  void dispose() {
    super.dispose();
    TextInputReceiver.instance.removeDisableScope(this);
  }

  @override
  bool get disableTextInputReceiver => hasFocus;
}

class _InputClient with TextInputClient {
  _InputClient({
    required this.editingValue,
    required this.onConnectionClosed,
  });

  final ValueNotifier<TextEditingValue> editingValue;
  final VoidCallback onConnectionClosed;

  @override
  void connectionClosed() {
    onConnectionClosed.call();
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
