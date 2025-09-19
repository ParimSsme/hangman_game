import 'package:flutter/material.dart';

class GallowsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final baseY = size.height - 20;

    canvas.drawLine(Offset(20, baseY), Offset(size.width - 20, baseY), paint);

    canvas.drawLine(Offset(50, baseY), const Offset(50, 20), paint);

    final topBeamEndX = size.width * 0.8;
    canvas.drawLine(const Offset(50, 20), Offset(topBeamEndX, 20), paint);

    canvas.drawLine(Offset(topBeamEndX, 20), Offset(topBeamEndX, 50), paint);
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
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final hangX = size.width * 0.8;
    final headCenter = Offset(hangX, 70);

    /// Draw parts step by step
    if (stage > 0) {
      /// Head
      canvas.drawCircle(headCenter, 20, paint);
    }
    if (stage > 1) {
      /// Body
      canvas.drawLine(Offset(hangX, 90), Offset(hangX, 150), paint);
    }
    if (stage > 2) {
      /// Left arm
      canvas.drawLine(Offset(hangX, 100), Offset(hangX - 40, 120), paint);
    }
    if (stage > 3) {
      /// Right arm
      canvas.drawLine(Offset(hangX, 100), Offset(hangX + 40, 120), paint);
    }
    if (stage > 4) {
      /// Left leg
      canvas.drawLine(Offset(hangX, 150), Offset(hangX - 30, 200), paint);
    }
    if (stage > 5) {
      /// Right leg
      canvas.drawLine(Offset(hangX, 150), Offset(hangX + 30, 200), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

