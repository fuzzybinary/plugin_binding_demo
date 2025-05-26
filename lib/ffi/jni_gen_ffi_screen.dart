import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jni/jni.dart';

import '../common/marker_painter.dart';
import '../common/performance_table.dart';
import '../metric.dart';
import '../open_cv_jni.dart' as cv;

class JniGenFfiScreen extends StatefulWidget {
  const JniGenFfiScreen({super.key});

  @override
  State<JniGenFfiScreen> createState() => _JniGenFfiScreenState();
}

class _JniGenFfiScreenState extends State<JniGenFfiScreen> {
  static const imageLocation = 'assets/singlemarkersoriginal.jpg';
  static const totalIterations = 50;

  ui.Image? _imageAsset;
  ByteData? _byteData;
  List<int> _markerIds = [];
  List<List<List<double>>> _markerCorners = [];

  String status = '';

  bool _runningTest = false;
  int _iterations = 0;

  final Metric classifyTime = Metric('Classify Time');
  final Metric fullResponse = Metric('Full Time');

  late cv.Dictionary arucoDictionary;
  late cv.ArucoDetector arucoDetector;

  @override
  void initState() {
    super.initState();

    arucoDictionary =
        cv.Objdetect.getPredefinedDictionary(cv.Objdetect.DICT_6X6_250)!;
    arucoDetector = cv.ArucoDetector.new$1(
      arucoDictionary,
      cv.DetectorParameters(),
    );
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

  void _runTestMulti() async {
    if (_byteData == null) {
      setState(() {
        status = 'Failed to get byte data from image :(';
      });
      return;
    }

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
      await Future.delayed(Duration.zero);
    }

    setState(() {
      _runningTest = false;
    });
  }

  Future<void> _runTest() async {
    final Stopwatch totalTime = Stopwatch();
    totalTime.start();
    using((arena) {
      JByteArray data = JByteArray.from(_byteData!.buffer.asUint8List())
        ..releasedBy(arena);

      final imageMat =
          cv.Mat.new$2(
              _imageAsset!.height,
              _imageAsset!.width,
              cv.CvType.CV_8UC4,
            )
            ..releasedBy(arena)
            ..put$8(0, 0, data);

      final markerCornerList = <cv.Mat?>[].toJList(cv.Mat.type)
        ..releasedBy(arena);
      final ids = cv.Mat.new$1()..releasedBy(arena);

      final Stopwatch classifyTimer = Stopwatch();
      classifyTimer.start();
      arucoDetector.detectMarkers$1(imageMat, markerCornerList, ids);
      classifyTimer.stop();
      classifyTime.addSample(classifyTimer.elapsedMicroseconds / 1000);
      if (markerCornerList.isEmpty) {
        status = 'Failed to find markers.';
        return;
      }

      final idArray = JIntArray(ids.total())..releasedBy(arena);
      ids.get$4(0, 0, idArray);
      _markerIds = List<int>.from(idArray);

      final markerList = List<List<List<double>>>.empty(growable: true);
      for (
        int markerIndex = 0;
        markerIndex < markerCornerList.length;
        ++markerIndex
      ) {
        final markerCorners = markerCornerList[markerIndex];
        final buff = JFloatArray(markerCorners!.total() * 2)..releasedBy(arena);
        markerCorners.get$6(0, 0, buff);
        final cornerList = List<List<double>>.empty(growable: true);
        for (
          int cornerIndex = 0;
          cornerIndex < markerCorners.cols();
          ++cornerIndex
        ) {
          cornerList.add([buff[cornerIndex * 2], buff[cornerIndex * 2 + 1]]);
        }
        markerList.add(cornerList);
      }
      _markerCorners = markerList;
    });
    fullResponse.addSample(totalTime.elapsedMicroseconds / 1000);
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
