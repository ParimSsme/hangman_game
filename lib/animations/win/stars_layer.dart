import 'dart:math';
import 'package:flutter/material.dart';

class StarsLayer extends StatelessWidget {
  const StarsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(6, (i) {
        double angle = (i / 6) * 2 * pi;
        return Align(
          alignment: Alignment(cos(angle), sin(angle)),
          child: Icon(
            Icons.star,
            color: Colors.yellow.shade600,
            size: 22,
          ),
        );
      }),
    );
  }
}
