import 'package:april/widgets/periodic_scale_animation_widget.dart';
import 'package:april/widgets/shake_widget.dart';
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
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      PeriodicScaleAnimationWidget(
        detectorKey: const ValueKey<String>('周期性缩放动画'),
        child: const Icon(Icons.diamond, size: 48),
      ),
      ShakeWidget(
        detectorKey: const ValueKey<String>('旋转动画'),
        child: const Icon(Icons.title, size: 48),
      ),
    ]);
  }
}
