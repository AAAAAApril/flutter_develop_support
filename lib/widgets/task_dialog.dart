import 'dart:async';

import 'package:flutter/material.dart';

///任务弹窗
class TaskDialog<T> extends StatefulWidget {
  ///把需要执行的任务包裹到弹窗弹出期间，任务执行结束 或者抛出异常，弹窗自动关闭
  static Future<T> show<T>(
    BuildContext context, {
    required Future<T> Function() task,
    Color? barrierColor = Colors.black54,
    bool useRootNavigator = true,
    WidgetBuilder? contentBuilder,
  }) async {
    final Completer<T> completer = Completer<T>();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: TaskDialog<T>._(
          task: task,
          resultCompleter: completer,
          contentBuilder: contentBuilder,
        ),
      ),
    );
    return completer.future;
  }

  ///弹窗内容布局构造器
  static WidgetBuilder? dialogContentBuilder;

  const TaskDialog._({
    Key? key,
    required this.task,
    required this.resultCompleter,
    this.contentBuilder,
  }) : super(key: key);

  ///需要执行的任务
  final Future<T> Function() task;

  ///结果回调函数
  final Completer<T> resultCompleter;

  ///内容构造器
  final WidgetBuilder? contentBuilder;

  @override
  _TaskDialogState<T> createState() => _TaskDialogState<T>();
}

class _TaskDialogState<T> extends State<TaskDialog<T>> {
  late ModalRoute route;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      //延迟一会儿再执行任务
      Future.delayed(const Duration(milliseconds: 100), () {
        route = ModalRoute.of(context)!;
        _runTask();
      });
    });
  }

  ///执行任务
  void _runTask() {
    widget.task.call().then((value) {
      route.isActive;
      route.isCurrent;
      //关闭弹窗
      Navigator.removeRoute(context, route);
      //回调结果
      widget.resultCompleter.complete(value);
    }).catchError((Object e, StackTrace trace) {
      //关闭弹窗
      Navigator.removeRoute(context, route);
      //回调异常
      widget.resultCompleter.completeError(e, trace);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.contentBuilder?.call(context) ??
        TaskDialog.dialogContentBuilder?.call(context) ??
        const SizedBox.shrink();
  }
}
