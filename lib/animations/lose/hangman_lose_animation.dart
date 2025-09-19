import 'dart:math';
import 'package:flutter/material.dart';

class HangmanLoseAnimation extends StatelessWidget {
  final Animation<double> animation;
  final Widget stickman;
  final Widget gallows;

  const HangmanLoseAnimation({
    super.key,
    required this.animation,
    required this.stickman,
    required this.gallows,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        double fall = animation.value * 150;
        double rotation = animation.value * pi / 6;

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            gallows,
            Transform.translate(
              offset: Offset(0, fall),
              child: Transform.rotate(angle: rotation, child: stickman),
            ),
          ],
        );
      },
    );
  }
}

