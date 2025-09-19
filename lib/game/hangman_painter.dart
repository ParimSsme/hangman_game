import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class GallowsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final baseY = size.height - 20;

    // Gallows
    canvas.drawLine(Offset(20, baseY), Offset(size.width - 20, baseY), paint);
    canvas.drawLine(Offset(50, baseY), Offset(50, 20), paint);
    canvas.drawLine(Offset(50, 20), Offset(size.width / 2, 20), paint);
    canvas.drawLine(Offset(size.width / 2, 20), Offset(size.width / 2, 50), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StickmanPainter extends CustomPainter {
  final int stage;
  StickmanPainter(this.stage);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final headCenter = Offset(size.width / 2, 70);

    if (stage > 0) canvas.drawCircle(headCenter, 20, paint); // Head
    if (stage > 1) canvas.drawLine(Offset(size.width / 2, 90), Offset(size.width / 2, 150), paint); // Body
    if (stage > 2) canvas.drawLine(Offset(size.width / 2, 100), Offset(size.width / 2 - 40, 120), paint); // Left arm
    if (stage > 3) canvas.drawLine(Offset(size.width / 2, 100), Offset(size.width / 2 + 40, 120), paint); // Right arm
    if (stage > 4) canvas.drawLine(Offset(size.width / 2, 150), Offset(size.width / 2 - 30, 200), paint); // Left leg
    if (stage > 5) canvas.drawLine(Offset(size.width / 2, 150), Offset(size.width / 2 + 30, 200), paint); // Right leg
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
