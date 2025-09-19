import 'dart:math';
import 'package:flutter/material.dart';

class RainbowBackground extends StatelessWidget {
  final double progress;
  const RainbowBackground({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: RainbowPainter(progress));
  }
}

class RainbowPainter extends CustomPainter {
  final double progress;
  RainbowPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          Colors.indigo,
          Colors.purple,
          Colors.red,
        ],
        transform: GradientRotation(progress * 2 * pi),
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant RainbowPainter oldDelegate) => false;
}
