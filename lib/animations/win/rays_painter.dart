import 'dart:math';
import 'package:flutter/material.dart';

class RaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.7)
      ..strokeWidth = 3;

    final center = Offset(size.width / 2, size.height / 2);
    const int rays = 16;
    const double radius = 80;

    for (int i = 0; i < rays; i++) {
      double angle = (i / rays) * 2 * pi;
      final start = center + Offset(cos(angle) * 20, sin(angle) * 20);
      final end = center + Offset(cos(angle) * radius, sin(angle) * radius);
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
