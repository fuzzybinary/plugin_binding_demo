import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  List<int> _markerIds = Int32List(0);
  List<List<List<double>>> _markerCorners = [];

  String status = '';

  void _runTestMulti() async {
    setState(() {
      callMetric.reset();
      fullResponse.reset();
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
      callMetric.reset();
      fullResponse.reset();
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
    final rawImageData = await rootBundle.load(imageLocation);
    final imageAsset = await decodeImageFromList(
      rawImageData.buffer.asUint8List(),
    );
    final byteData = await imageAsset.toByteData(
      format: ImageByteFormat.rawStraightRgba,
    );
    if (byteData == null) {
      setState(() {
        status = 'Failed to get byte data from image :(';
      });
      return;
    }

    final stopwatch = Stopwatch();
    stopwatch.start();
    final future = methodChannel.invokeMapMethod('detectQrCodes', {
      'mat': {
        'width': imageAsset.width,
        'height': imageAsset.height,
        'data': byteData.buffer.asUint8List(),
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
        title: Text('Method Channels'),
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

class MarkerPainter extends CustomPainter {
  final List<int> markerIds;
  List<List<List<double>>> markerCorners = [];

  MarkerPainter(this.markerIds, this.markerCorners);

  @override
  void paint(Canvas canvas, Size size) {
    final scaleFactor = size.width / 640.0;
    final linePaint =
        Paint()
          ..color = Colors.green
          ..strokeWidth = 2.0;
    for (final marker in markerCorners) {
      for (int i = 0; i < 4; ++i) {
        final a = marker[i];
        final b = marker[(i + 1) % 4];
        canvas.drawLine(
          Offset(a[0], a[1]) * scaleFactor,
          Offset(b[0], b[1]) * scaleFactor,
          linePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
