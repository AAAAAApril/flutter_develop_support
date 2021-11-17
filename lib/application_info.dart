import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

///项目的一些属性
class ApplicationInfo {
  ///应用包名
  final String packageName;

  ///应用名
  final String appName;

  ///应用版本号
  final String appVersion;

  ///应用构建号
  final int appBuildNumber;

  ///支持的所有 ABI
  final List<String> supportAbis;

  ///支持的所有 64 位 ABI
  final List<String> support64Abis;

  const ApplicationInfo._({
    required this.packageName,
    required this.appName,
    required this.appVersion,
    required this.appBuildNumber,
    required this.supportAbis,
    required this.support64Abis,
  });

  static const MethodChannel _channel =
      MethodChannel('april_application_info_method_channel_name');

  static ApplicationInfo? _info;

  static Future<ApplicationInfo> get() async {
    if (_info != null) {
      return _info!;
    }
    final Map result = await _channel
        .invokeMethod<Map>('applicationInfo')
        .then<Map>((value) => value ?? {})
        .catchError((Object e, StackTrace trace) {
      debugPrint(e.toString());
      debugPrint(trace.toString());
      return {};
    });
    _info = ApplicationInfo._(
      packageName: result['packageName'] ?? '',
      appName: result['appName'] ?? '',
      appVersion: result['appVersion'] ?? '',
      appBuildNumber: result['appBuildNumber'] ?? 0,
      supportAbis: List<String>.from(
        <dynamic>[
          ...(result['supportAbis'] ?? []),
        ],
      ),
      support64Abis: List<String>.from(
        <dynamic>[
          ...(result['support64Abis'] ?? []),
        ],
      ),
    );
    return _info!;
  }

  Map<String,dynamic> toMap(){
    return {
      'packageName':packageName,
      'appName':appName,
      'appVersion':appVersion,
      'appBuildNumber':appBuildNumber,
      'supportAbis':supportAbis,
      'support64Abis':support64Abis,
    };
  }

}
