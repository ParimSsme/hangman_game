import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiPainter extends CustomPainter {
  final double progress;
  final Random random = Random(42);

  ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 30; i++) {
      final paint = Paint()
        ..color = Colors.primaries[i % Colors.primaries.length]
            .withOpacity(1 - progress);
      final dx = random.nextDouble() * size.width;
      final dy = progress * size.height + random.nextDouble() * 50;
      canvas.drawCircle(Offset(dx, dy), 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) => false;
}
