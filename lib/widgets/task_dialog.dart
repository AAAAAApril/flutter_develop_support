import 'dart:async';

import 'package:flutter/material.dart';

///任务弹窗
class TaskDialog<T> extends StatefulWidget {
  ///把需要执行的任务包裹到弹窗弹出期间，任务执行结束 或者抛出异常，弹窗自动关闭
  ///[task] 执行的任务抛出异常时，会返回 null
  static Future<T?> show<T>(
    BuildContext context, {
    required Future<T> Function() task,
    Color? barrierColor = Colors.black54,
    bool useRootNavigator = true,
    WidgetBuilder? contentBuilder,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: TaskDialog._(
          task: task,
          contentBuilder: contentBuilder,
        ),
      ),
    ).catchError((Object e, StackTrace trace) {
      debugPrint(e.toString());
      debugPrint(trace.toString());
      return null;
    });
  }

  ///弹窗内容布局构造器
  static WidgetBuilder? dialogContentBuilder;

  const TaskDialog._({
    Key? key,
    required this.task,
    this.contentBuilder,
  }) : super(key: key);

  ///需要执行的任务
  final Future<T> Function() task;

  ///内容构造器
  final WidgetBuilder? contentBuilder;

  @override
  _TaskDialogState<T> createState() => _TaskDialogState<T>();
}

class _TaskDialogState<T> extends State<TaskDialog<T>> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      //延迟一会儿再执行任务
      Future.delayed(const Duration(milliseconds: 100), () {
        _runTask();
      });
    });
  }

  ///执行任务
  void _runTask() {
    widget.task.call().then<void>((value) {
      Navigator.pop<T>(context, value);
    }).catchError((Object e, StackTrace trace) {
      debugPrint(e.toString());
      debugPrint(trace.toString());
      Navigator.pop<T>(context, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.contentBuilder?.call(context) ??
        TaskDialog.dialogContentBuilder?.call(context) ??
        const SizedBox.shrink();
  }
}
