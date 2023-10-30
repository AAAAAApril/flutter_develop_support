import 'package:april_flutter_utils/april_flutter_utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const ExampleWidget(),
      ),
    );
  }
}

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({Key? key}) : super(key: key);

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  late VisibilityValueNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = VisibilityValueNotifier();
    notifier.addListener(onVisibilityChanged);
  }

  @override
  void dispose() {
    super.dispose();
    notifier.dispose();
  }

  void onVisibilityChanged() {
    debugPrint('>>>[可见性][${notifier.value}]');
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetectorWidget(
      detectorKey: ValueKey(runtimeType),
      visibilityNotifier: notifier,
      child: Column(children: [
        PeriodicScaleAnimationWidget(
          detectorKey: const ValueKey<String>('周期性缩放动画'),
          child: const Icon(Icons.diamond, size: 48),
        ),
        ShakeWidget(
          detectorKey: const ValueKey<String>('旋转动画'),
          child: const Icon(Icons.title, size: 48),
        ),
      ]),
    );
  }
}
