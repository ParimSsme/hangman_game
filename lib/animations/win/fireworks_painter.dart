import 'dart:math';
import 'package:flutter/material.dart';

class FireworksLayer extends StatelessWidget {
  final double progress;
  const FireworksLayer({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: FireworksPainter(progress));
  }
}

class FireworksPainter extends CustomPainter {
  final double progress;
  final Random random = Random(42);

  FireworksPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 8; i++) {
      final paint = Paint()
        ..color = Colors.primaries[i % Colors.primaries.length]
            .withOpacity(1 - progress)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      double radius = 40 + progress * 80;
      double angle = (i / 8) * 2 * pi;

      final end = center + Offset(cos(angle) * radius, sin(angle) * radius);
      canvas.drawCircle(end, 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FireworksPainter oldDelegate) => false;
}
