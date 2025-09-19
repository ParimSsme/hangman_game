import 'dart:math';
import 'package:flutter/material.dart';
import '../confetti_painter.dart';
import 'rainbow_painter.dart';
import 'fireworks_painter.dart';
import 'aura_layer.dart';
import 'rays_painter.dart';
import 'stars_layer.dart';

class HangmanWinAnimation extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const HangmanWinAnimation({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, stickman) {
        double scale = 1 + 0.2 * sin(animation.value * pi * 4);
        double rotation = animation.value * 2 * pi;
        double auraScale = 1 + animation.value * 1.5;
        double auraOpacity = (1 - animation.value).clamp(0.0, 1.0);
        double raysRotation = animation.value * pi * 2;
        double shake = sin(animation.value * pi * 20) * 8;
        double crownDrop = (1 - animation.value) * -80;

        return Transform.translate(
          offset: Offset(shake, 0), /// Screen shake
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: RainbowBackground(progress: animation.value),
              ),

              Positioned.fill(
                child: FireworksLayer(progress: animation.value),
              ),


              AuraLayer(scale: auraScale, opacity: auraOpacity),


              Transform.rotate(
                angle: raysRotation,
                child: CustomPaint(
                  size: const Size(200, 200),
                  painter: RaysPainter(),
                ),
              ),


              Transform.scale(scale: scale, child: stickman),


              Positioned(
                top: 50 + crownDrop,
                child: Icon(
                  Icons.emoji_events,
                  color: Colors.amber.shade700,
                  size: 40,
                ),
              ),


              CustomPaint(
                size: const Size(200, 250),
                painter: ConfettiPainter(animation.value),
              ),


              Transform.rotate(
                angle: rotation,
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: StarsLayer(),
                ),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }
}
