import 'package:flutter/foundation.dart';

///轮询执行，直到完成
class Task {
  Task._({
    required this.task,
    required this.delays,
    required this.maxTimes,
    this.onDone,
    this.onTimeout,
  }) : assert(delays.isNotEmpty);

  ///循环执行任务
  factory Task({
    required ValueGetter<Future<bool>> task,
    VoidCallback? onDone,
    VoidCallback? onTimeout,
    List<Duration> delays = const <Duration>[],
    Duration defaultDelay = const Duration(seconds: 3),
    int maxTimes = 33,
  }) =>
      Task._(
        task: task,
        delays: delays.isEmpty ? <Duration>[defaultDelay] : delays,
        maxTimes: maxTimes,
        onDone: onDone,
        onTimeout: onTimeout,
      );

  ///接口重试任务
  factory Task.retry({
    required ValueGetter<Future<bool>> task,
    List<Duration> delays = const <Duration>[
      Duration(seconds: 1),
      Duration(seconds: 3),
      Duration(seconds: 6),
    ],
    int maxTimes = 4,
  }) =>
      Task._(task: task, delays: delays, maxTimes: maxTimes);

  ///需要执行的任务
  final ValueGetter<Future<bool>> task;

  ///每一次执行失败时，再次执行任务的等待时长列表
  ///当循环执行任务时，若需要执行的任务次数超过了 [delays] 的长度，
  ///那么后面再执行时，就以 [delays] 最后一个值作为等待延时
  final List<Duration> delays;

  ///最大尝试次数
  ///[maxTimes] 小于等于 0 表示无限循环
  final int maxTimes;

  ///完成时的回调
  ///[run] 函数也是阻塞执行的，它的返回同样意味着完成，除非被提前取消，或者超过了最大次数限制
  final VoidCallback? onDone;

  ///超过了最大次数限制，但仍然没有完成
  final VoidCallback? onTimeout;

  ///是否已经取消
  bool _canceled = false;

  ///是否已经完成
  bool _done = false;

  ///是否已经超过了最大次数限制
  bool _timedOut = false;

  bool get canceled => _canceled;

  bool get done => _done;

  bool get timedOut => _timedOut;

  ///开始执行任务
  Future<void> run() async {
    for (int index = 0;
    //未取消
    !_canceled &&
        //未结束
        !_done &&
        //无限循环，或者执行次数还未达到最大次数
        (maxTimes <= 0 || index < maxTimes);
    index++) {
      //执行该任务
      await task.call().then<void>((value) {
        if (value == true) {
          _done = true;
        }
      }).catchError((_) {
        //不处理异常情况
      }).whenComplete(() async {
        //已经取消
        if (_canceled) {
          return;
        }
        //还未取消
        //已经完成了
        if (_done) {
          onDone?.call();
        }
        //未完成
        else {
          //已经超过了最大次数限制了
          if (maxTimes > 0 && index >= maxTimes) {
            _timedOut = true;
            onTimeout?.call();
            return;
          }
          //等待一段时间继续执行
          final Duration delay;
          //次数还未超过，正常取值
          if (delays.length > index) {
            delay = delays[index];
          }
          //次数超过了，取最后一个值
          else {
            delay = delays.last;
          }
          //开始等待
          await Future.delayed(delay);
        }
      });
    }
  }

  ///再次尝试
  ///Tips：请先判断是否已经 完成、取消，或者超时，以避免在循环执行任务的过程中触发 [retry]
  Future<void> retry() {
    _canceled = false;
    _done = false;
    _timedOut = false;
    return run();
  }

  ///取消任务
  ///取消任务之后，即使任务在这期间完成了，也不会回调 [onDone]
  Future<void> cancel() async {
    _canceled = true;
  }
}
