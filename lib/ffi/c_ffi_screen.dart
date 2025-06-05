import 'dart:ffi';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/marker_painter.dart';
import '../common/performance_table.dart';
import '../metric.dart';
import '../open_cv_c.dart';

class CFfiScreen extends StatefulWidget {
  const CFfiScreen({super.key});

  @override
  State<CFfiScreen> createState() => _CFfiScreenState();
}

class _CFfiScreenState extends State<CFfiScreen> {
  static const imageLocation = 'assets/singlemarkersoriginal.jpg';
  static const totalIterations = 50;

  late OpenCv opencv;

  bool _runningTest = false;
  int _iterations = 0;

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

    if (Platform.isAndroid) {
      final dylib = DynamicLibrary.open('libopencv_wrapper.so');
      opencv = OpenCv(dylib);
    } else {
      final dylib = DynamicLibrary.executable();
      opencv = OpenCv(dylib);
    }
    opencv.initializeOpenCV();
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
      _runTest();
      setState(() {
        _iterations++;
      });
      await Future.delayed(Duration.zero);
    }

    setState(() {
      _runningTest = false;
    });
  }

  void _runTestOnce() {
    setState(() {
      _resetMetrics();
      _runningTest = true;
      _iterations = 0;
    });
    _runTest();
    setState(() {
      _runningTest = false;
      _iterations++;
    });
  }

  void _runTest() {
    if (_byteData == null) {
      setState(() {
        status = 'Failed to get byte data from image :(';
      });
      return;
    }

    final Stopwatch totalTime = Stopwatch();
    totalTime.start();

    using((arena) {
      final imageDataList = _byteData!.buffer.asUint8List();
      final imageData = arena.allocate<Uint8>(imageDataList.length);
      imageData
          .asTypedList(imageDataList.length)
          .setRange(0, imageDataList.length, imageDataList);

      final Stopwatch classifyTimer = Stopwatch();
      classifyTimer.start();
      final markerResult = opencv.decodeMarkers(
        imageData,
        _imageAsset!.width,
        _imageAsset!.height,
      );
      classifyTimer.stop();
      classifyTime.addSample(classifyTimer.elapsedMicroseconds / 1000);

      final count = markerResult.ref.markersCount;
      final markerIds = <int>[];
      final markerCorners = <List<List<double>>>[];
      for (int i = 0; i < count; ++i) {
        final marker = (markerResult.ref.markers + i);
        markerIds.add(marker.ref.id);
        final markerCorner = [
          [marker.ref.corners[0].toDouble(), marker.ref.corners[1].toDouble()],
          [marker.ref.corners[2].toDouble(), marker.ref.corners[3].toDouble()],
          [marker.ref.corners[4].toDouble(), marker.ref.corners[5].toDouble()],
          [marker.ref.corners[6].toDouble(), marker.ref.corners[7].toDouble()],
        ];
        markerCorners.add(markerCorner);
      }
      opencv.freeDecodeResult(markerResult);

      _markerIds = markerIds;
      _markerCorners = markerCorners;
    });

    fullResponse.addSample(totalTime.elapsedMicroseconds / 1000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('C FFI'),
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
            PerformanceTable(metrics: [classifyTime, fullResponse]),
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
