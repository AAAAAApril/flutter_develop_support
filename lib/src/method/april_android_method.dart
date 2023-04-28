import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'app_package_info.dart';
import 'resolve_activity_info.dart';

class AprilAndroidMethod {
  factory AprilAndroidMethod() => _instance ??= AprilAndroidMethod._();
  
  static AprilAndroidMethod? _instance;

  AprilAndroidMethod._() {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  static const MethodChannel _channel = MethodChannel(
    'April.FlutterDevelopSupport.MethodChannelName',
  );

  ///接收 Intent data
  final StreamController<String?> _onIntentDataController = StreamController<String?>.broadcast();

  Stream<String?> get onNewIntentData => _onIntentDataController.stream;

  ///回退到桌面
  void backToDesktop() {
    if (!Platform.isAndroid) {
      return;
    }
    _channel.invokeMethod('backToDesktop');
  }

  ///关闭应用
  void closeApplication() {
    if (!Platform.isAndroid) {
      return;
    }
    _channel.invokeMethod('closeApplication');
  }

  ///重启应用
  void restartApplication() {
    if (!Platform.isAndroid) {
      return;
    }
    _channel.invokeMethod('restartApplication');
  }

  ///根据包名检测安装的
  Future<AppPackageInfo?> installedAppInfo(String packageName) async {
    if (!Platform.isAndroid) {
      return null;
    }
    return _channel.invokeMethod<Map>('installedAppInfo', packageName).then<AppPackageInfo?>((value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      return AppPackageInfo(
        packageName: (value['packageName'] as String?) ?? '',
        versionName: (value['versionName'] as String?) ?? '',
        versionCode: (value['versionCode'] as int?) ?? 0,
        firstInstallTime: DateTime.fromMillisecondsSinceEpoch(
          (value['firstInstallTime'] as int?) ?? 0,
        ),
        lastUpdateTime: DateTime.fromMillisecondsSinceEpoch(
          (value['lastUpdateTime'] as int?) ?? 0,
        ),
      );
    }).catchError((_) => null);
  }

  ///查找所有支持这个跳转链的 Activity 的信息
  Future<List<ResolveActivityInfo>> supportedActivities(String url) async {
    if (!Platform.isAndroid) {
      return <ResolveActivityInfo>[];
    }
    return _channel.invokeMethod<List>('supportedActivities', url).then<List<ResolveActivityInfo>>((value) {
      if (value == null || value.isEmpty) {
        return <ResolveActivityInfo>[];
      }
      return List<ResolveActivityInfo>.from(
        value.map<ResolveActivityInfo?>((e) {
          if (e is! Map) {
            return null;
          }
          if (e.isEmpty) {
            return null;
          }
          final String packageName = (e['packageName'] as String?) ?? '';
          final String className = (e['className'] as String?) ?? '';
          if (packageName.isEmpty && className.isEmpty) {
            return null;
          }
          return ResolveActivityInfo(
            packageName: packageName,
            className: className,
          );
        }),
      );
    }).catchError((_) => <ResolveActivityInfo>[]);
  }

  ///加载跳转链
  Future<bool> launchUrl(
    //需要加载的跳转链
    String url, {
    //指定包名
    String packageName = '',
    //指定类名（完整）
    String className = '',
  }) async {
    if (!Platform.isAndroid) {
      return false;
    }
    return _channel
        .invokeMethod<bool>('launchUrl', {
          'packageName': packageName,
          'className': className,
          'url': url,
        })
        .then<bool>((value) => value ?? false)
        .catchError((_) => false);
  }

  ///获取 Intent 的 data 字段数据
  Future<String?> getIntentData() async {
    if (!Platform.isAndroid) {
      return null;
    }
    return _channel
        .invokeMethod<dynamic>('getIntentData')
        .then<String?>((value) => value as String?)
        .catchError((_) => null);
  }

  //接收到原生端发来的消息
  Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onNewIntentData':
        try {
          _onIntentDataController.add(call.arguments as String?);
        } catch (_) {
          //ignore
        }
        return 0;
      default:
        return;
    }
  }
}
