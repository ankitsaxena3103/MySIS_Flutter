import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  SignaturePainter({
    required this.points,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      if (current == null || next == null) {
        continue;
      }

      canvas.drawLine(
        current,
        next,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant SignaturePainter oldDelegate,
  ) {
    return oldDelegate.points != points;
  }
}
