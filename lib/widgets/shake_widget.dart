import 'package:april/widgets/rotation_widget.dart';
import 'package:flutter/widgets.dart';

///左右摇晃的 组件
@Deprecated('Use RotationWidget instead.')
class ShakeWidget extends RotationWidget {
  const ShakeWidget({
    Key? key,
    required Key detectorKey,
    required Widget child,
    List<double> angleValues = const <double>[0, -45, 45, 0],
    List<Duration> durations = const <Duration>[
      Duration(milliseconds: 150),
      Duration(milliseconds: 300),
      Duration(milliseconds: 150),
    ],
    Duration? restDuration,
  }) : super(
          key: key,
          detectorKey: detectorKey,
          child: child,
          angleValues: angleValues,
          durations: durations,
          restDuration: restDuration,
        );
}
