// import 'dart:async';
// import 'dart:math' as math;
//
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:hey/configuration/AppAssets.dart';
// import 'package:hey/generated/l10n.dart';
//
// import 'package:hey/routes/ContextObserver.dart';
// import 'package:hey/utils/AppUtils.dart';
// import 'package:hey/utils/Extensions.dart';
// import 'package:hey/widget/public/ImageWidget.dart';
// import 'package:provider/provider.dart';
//
// const String routeName = 'StateDialog_RouteName';
//
// ///多状态弹窗
// class StateDialog extends StatefulWidget {
//   static StateController _show() {
//     final StateController controller = StateController();
//     showDialog<void>(
//       context: ContextObserver.instance.context,
//       //不允许关闭
//       barrierDismissible: false,
//       routeSettings: const RouteSettings(name: routeName),
//       useRootNavigator: !AppUtils.isDebug,
//       builder: (context) => WillPopScope(
//         //拦截返回操作，禁止关闭
//         onWillPop: () async => false,
//         child: ChangeNotifierProvider(
//           create: (context) => controller,
//           child: StateDialog._(controller: controller),
//         ),
//       ),
//     );
//     return controller;
//   }
//
//   ///把异步任务 包装到状态弹窗内
//   static Future<bool> run({
//     required Future<bool> Function() task,
//     VoidCallback? onSucceed,
//     VoidCallback? onFailed,
//     Duration succeedDuration = const Duration(seconds: 1),
//     bool showFailedToast = true,
//   }) {
//     final StateController controller = StateDialog._show();
//     return controller._dialogCreated.future.then<bool>(
//           (value) => task.call().then<bool>((value) async {
//         if (value) {
//           await controller._onSucceed(succeedDuration).whenComplete(() {
//             onSucceed?.call();
//           });
//         } else {
//           await controller._onError().whenComplete(() {
//             onFailed?.call();
//             if (showFailedToast) {
//               AppUtils.toast(
//                   S.of(ContextObserver.instance.context).executionFailed);
//             }
//           });
//         }
//         return value;
//       }).catchError((_) async {
//         await controller._onError().whenComplete(() {
//           onFailed?.call();
//           if (showFailedToast) {
//             AppUtils.toast(
//                 S.of(ContextObserver.instance.context).executionFailed);
//           }
//         });
//         return false;
//       }),
//     );
//   }
//
//   ///需要获取结果的异步任务
//   static Future<T?> result<T>({
//     required Future<StateWrapper<T>> Function() task,
//   }) {
//     final StateController controller = StateDialog._show();
//     return controller._dialogCreated.future.then<T?>(
//           (value) => task.call().then<T?>((value) async {
//         if (value.succeed) {
//           await controller._onSucceed();
//         } else {
//           await controller._onError();
//         }
//         return value.data;
//       }).catchError((_) async {
//         await controller._onError();
//         return null;
//       }),
//     );
//   }
//
//   const StateDialog._({Key? key, required this.controller}) : super(key: key);
//
//   final StateController controller;
//
//   @override
//   _StateDialogState createState() => _StateDialogState();
// }
//
// class _StateDialogState extends State<StateDialog> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       //延迟一会儿再上报弹窗创建完成
//       Future.delayed(const Duration(milliseconds: 100), () {
//         if (!widget.controller._dialogCreated.isCompleted) {
//           widget.controller._dialogCreated.complete();
//           widget.controller.__context = context;
//         }
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ValueListenableBuilder<_StateConfig>(
//         valueListenable: widget.controller._loadingState,
//         builder: (context, value, child) => value.iconBuilder.call(context),
//       ),
//     );
//   }
// }
//
// ///状态控制器
// class StateController extends ChangeNotifier {
//   StateController() : _dismissed = false;
//
//   ///绑定的 context
//   BuildContext? _context;
//
//   set __context(BuildContext value) {
//     _context = value;
//     //如果已经被标记为取消了，则直接关闭
//     if (_dismissed) {
//       Route<dynamic>? route = ModalRoute.of(value);
//       if (route != null) {
//         Navigator.removeRoute(value, route);
//       }
//     }
//   }
//
//   ///弹窗界面是否已经创建完成
//   final Completer<void> _dialogCreated = Completer<void>();
//
//   ///是否已经被取消
//   bool _dismissed;
//
//   ///当前状态
//   final ValueNotifier<_StateConfig> _loadingState = ValueNotifier<_StateConfig>(
//     //默认为加载中
//     _StateConfig(
//       title: (context) => S.of(context).waitMoment,
//       iconBuilder: (context) => _Loading(),
//     ),
//   );
//
//   ///出错状态（暂时没有这个状态）
//   Future<void> _onError() {
//     return Future<void>.delayed(Duration.zero, () async {
//       _dialogCreated.future.then<void>((value) {
//         _onDismiss();
//       });
//     });
//   }
//
//   ///成功状态
//   Future<void> _onSucceed([
//     //自动取消的延时时长
//     Duration autoDismissDuration = const Duration(milliseconds: 1500),
//   ]) {
//     return Future<void>.delayed(Duration.zero, () async {
//       _dialogCreated.future.then<void>((value) {
//         _onDismiss();
//       });
//     });
//   }
//
//   ///取消操作
//   void _onDismiss() {
//     //已经取消了则不处理
//     if (_dismissed) {
//       return;
//     }
//     _dismissed = true;
//     if (_context != null) {
//       Route<dynamic>? route = ModalRoute.of(_context!);
//       if (route != null) {
//         Navigator.removeRoute(_context!, route);
//       }
//     }
//   }
//
//   @override
//   @protected
//   void dispose() {
//     _context = null;
//     _loadingState.dispose();
//     super.dispose();
//   }
// }
//
// class _StateConfig {
//   const _StateConfig({
//     required this.title,
//     required this.iconBuilder,
//   });
//
//   ///标题
//   final StringGetter title;
//
//   ///图标
//   final WidgetBuilder iconBuilder;
// }
//
// class _Loading extends StatefulWidget {
//   @override
//   __LoadingState createState() => __LoadingState();
// }
//
// class __LoadingState extends State<_Loading> {
//   late Timer timer;
//   double angle = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
//       angle += math.pi / 4;
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Transform.rotate(
//       angle: angle,
//       child: const AssetImageWidget(AppIcons.loading, size: 52),
//     );
//   }
// }
//
// class StateWrapper<T> {
//   const StateWrapper.succeed(this.data) : succeed = true;
//
//   const StateWrapper.failed(this.data) : succeed = false;
//
//   final T? data;
//   final bool succeed;
// }
