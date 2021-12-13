import 'package:flutter/widgets.dart';

///通过 [BuildContext] 获取一个值
typedef ValueGetterByContext<T> = T Function(BuildContext context);
