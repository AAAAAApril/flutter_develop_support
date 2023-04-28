import 'dart:convert';
import 'dart:io';

import 'package:april_flutter_utils/april_flutter_utils.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

import 'package:html/parser.dart' as parser;

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
  late HttpClient client;

  @override
  void initState() {
    super.initState();
    client = HttpClient();
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  ///请求谷歌翻译
  void translate() async {
    HttpClientRequest request = await client.getUrl(
      Uri.parse(
        'https://translate.google.com/m?sl=en&tl=zh-CN&q=hello',
      ),
    );
    HttpClientResponse response = await request.close();
    String result = await response.transform(const Utf8Decoder()).join();
    dom.Document document = parser.parse(result);
    dom.Element? element = document.querySelector('div[class="result-container"]');
    debugPrint('翻译结果：${element?.text}');
  }

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
      ElevatedButton(
        onPressed: translate,
        child: const Text('请求谷歌翻译'),
      ),
    ]);
  }
}
