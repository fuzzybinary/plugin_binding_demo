import 'package:flutter/material.dart';

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
