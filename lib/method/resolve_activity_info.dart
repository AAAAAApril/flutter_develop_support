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
