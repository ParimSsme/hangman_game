import 'package:flutter/material.dart';

class Keyboard extends StatelessWidget {
  final void Function(String) onTap;
  final Set<String> disabled;

  const Keyboard({
    super.key,
    required this.onTap,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    const letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Wrap(
        spacing: 3,
        runSpacing: 4,
        alignment: WrapAlignment.center,
        children: letters.split("").map((letter) {
          final isDisabled = disabled.contains(letter);
          return TextButton(
            onPressed: isDisabled ? null : () => onTap(letter),
            style: TextButton.styleFrom(
              minimumSize: const Size(50, 50),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              letter,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }
}
