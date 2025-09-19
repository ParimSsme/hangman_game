import 'package:flutter/material.dart';

class AuraLayer extends StatelessWidget {
  final double scale;
  final double opacity;
  const AuraLayer({super.key, required this.scale, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.greenAccent.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
