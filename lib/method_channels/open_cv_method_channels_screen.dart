import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/marker_painter.dart';
import '../common/performance_table.dart';
import '../metric.dart';

class OpenCvMethodChannelsScreen extends StatefulWidget {
  const OpenCvMethodChannelsScreen({super.key});

  @override
  State<OpenCvMethodChannelsScreen> createState() =>
      _OpenCvMethodChannelsScreenState();
}

class _OpenCvMethodChannelsScreenState
    extends State<OpenCvMethodChannelsScreen> {
  static const imageLocation = 'assets/singlemarkersoriginal.jpg';
  static const totalIterations = 50;
  static const methodChannel = MethodChannel('fuzzybinary.binding_demo');

  bool _runningTest = false;
  int _iterations = 0;

  final Metric callMetric = Metric('Call Time');
  final Metric classifyTime = Metric('Classify Time');
  final Metric fullResponse = Metric('Full Time');

  ui.Image? _imageAsset;
  ByteData? _byteData;
  List<int> _markerIds = [];
  List<List<List<double>>> _markerCorners = [];

  String status = '';

  @override
  void initState() {
    super.initState();

    _getImageByteData();
  }

  void _getImageByteData() async {
    final rawImageData = await rootBundle.load(imageLocation);
    _imageAsset = await decodeImageFromList(rawImageData.buffer.asUint8List());
    _byteData = await _imageAsset!.toByteData(
      format: ui.ImageByteFormat.rawStraightRgba,
    );
  }

  void _resetMetrics() {
    callMetric.reset();
    classifyTime.reset();
    fullResponse.reset();
  }

  void _runTestMulti() async {
    setState(() {
      _resetMetrics();
      _runningTest = true;
      _iterations = 0;
    });
    for (int i = 0; i < totalIterations; ++i) {
      await _runTest();
      setState(() {
        _iterations++;
      });
    }

    setState(() {
      _runningTest = false;
    });
  }

  void _runTestOnce() async {
    setState(() {
      _resetMetrics();
      _runningTest = true;
      _iterations = 0;
    });
    await _runTest();
    setState(() {
      _runningTest = false;
      _iterations++;
    });
  }

  Future<void> _runTest() async {
    if (_byteData == null) {
      setState(() {
        status = 'Failed to get byte data from image :(';
      });
      return;
    }

    final stopwatch = Stopwatch();
    stopwatch.start();
    final future = methodChannel.invokeMapMethod('detectQrCodes', {
      'mat': {
        'width': _imageAsset!.width,
        'height': _imageAsset!.height,
        'data': _byteData!.buffer.asUint8List(),
      },
    });
    callMetric.addSample(stopwatch.elapsedMicroseconds / 1000);

    final result = await future.then((result) {
      fullResponse.addSample(stopwatch.elapsedMicroseconds / 1000);
      return result;
    });
    final classifyTimeMs = (result?['classifyTime'] as double);
    classifyTime.addSample(classifyTimeMs);

    _markerIds = (result?['markerIds'] as List).whereType<int>().toList();
    _markerCorners =
        (result?['markerCorners'] as List<Object?>).map((e) {
          return (e as List).map((e) {
            return (e as List).whereType<double>().toList();
          }).toList();
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Method Channels OpenCV'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Stack(
              children: [
                Image.asset(imageLocation),
                Positioned.fill(
                  child: CustomPaint(
                    painter: MarkerPainter(_markerIds, _markerCorners),
                  ),
                ),
              ],
            ),
            Text(status),
            Text('Iterations: $_iterations'),
            PerformanceTable(metrics: [callMetric, classifyTime, fullResponse]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: _runningTest ? null : _runTestOnce,
                  child: Text('Run Once'),
                ),
                ElevatedButton(
                  onPressed: _runningTest ? null : _runTestMulti,
                  child: Text('Run Experiment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
