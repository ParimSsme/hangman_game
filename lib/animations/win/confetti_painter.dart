import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiPainter extends CustomPainter {
  final double progress;
  final Random random = Random();

  ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final count = 80;
    for (int i = 0; i < count; i++) {
      final paint = Paint()
        ..color = Colors.primaries[i % Colors.primaries.length]
            .withValues(alpha: 0.8);

      // Each particle has its own "random seed"
      final seed = i * 997; // unique number per confetti
      final rand = Random(seed);

      final dx = rand.nextDouble() * size.width;
      final startY = rand.nextDouble() * size.height;

      // Make confetti fall down over time
      final dy = (startY + progress * size.height) % size.height;

      final radius = 3 + rand.nextDouble() * 3;

      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

