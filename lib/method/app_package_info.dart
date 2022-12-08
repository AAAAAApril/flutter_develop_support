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
