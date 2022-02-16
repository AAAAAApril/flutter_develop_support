import 'dart:io';

import 'package:flutter/services.dart';

class April {
  April._();

  static const MethodChannel _channel = MethodChannel(
    'April.FlutterDevelopSupport.MethodChannelName',
  );

  ///回退到桌面
  static void backToDesktop() {
    if (!Platform.isAndroid) {
      return;
    }
    _channel.invokeMethod('backToDesktop');
  }

  ///关闭应用
  static void closeApplication() {
    if (!Platform.isAndroid) {
      return;
    }
    _channel.invokeMethod('closeApplication');
  }

  ///重启应用
  static void restartApplication() {
    if (!Platform.isAndroid) {
      return;
    }
    _channel.invokeMethod('restartApplication');
  }

  ///根据包名检测安装的
  static Future<AppPackageInfo?> installedAppInfo(String packageName) {
    return _channel
        .invokeMethod<Map>('installedAppInfo', packageName)
        .then<AppPackageInfo?>((value) {
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
  static Future<List<ResolveActivityInfo>> supportedActivities(String url) {
    return _channel
        .invokeMethod<List>('supportedActivities', url)
        .then<List<ResolveActivityInfo>>((value) {
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
  static Future<bool> launchUrl(
    //需要加载的跳转链
    String url, {
    //指定包名
    String packageName = '',
    //指定类名（完整）
    String className = '',
  }) {
    return _channel
        .invokeMethod<bool>('launchUrl', {
          'packageName': packageName,
          'className': className,
          'url': url,
        })
        .then<bool>((value) => value ?? false)
        .catchError((_) => false);
  }
}

///应用的一些信息
class AppPackageInfo {
  const AppPackageInfo({
    required this.packageName,
    required this.versionName,
    required this.versionCode,
    required this.firstInstallTime,
    required this.lastUpdateTime,
  });

  ///包名
  final String packageName;

  ///版本号
  final String versionName;

  ///小版本号
  final int versionCode;

  ///第一次安装时间
  final DateTime firstInstallTime;

  ///最后一次更新时间
  final DateTime lastUpdateTime;

  @override
  String toString() {
    return 'AppPackageInfo{packageName: $packageName, versionName: $versionName, versionCode: $versionCode, firstInstallTime: $firstInstallTime, lastUpdateTime: $lastUpdateTime}';
  }
}

///能处理跳转链的 Activity 的信息
class ResolveActivityInfo {
  const ResolveActivityInfo({
    required this.packageName,
    required this.className,
  });

  ///包名
  ///例：com.a.b
  final String packageName;

  ///Activity 类名（完整）
  ///例：com.a.b.c.MainActivity
  final String className;

  @override
  String toString() {
    return 'ResolveActivityInfo{packageName: $packageName, className: $className}';
  }
}
