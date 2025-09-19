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
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: letters.split("").map((letter) {
        final isDisabled = disabled.contains(letter.toLowerCase());
        return ElevatedButton(
          onPressed: isDisabled ? null : () => onTap(letter.toLowerCase()),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDisabled ? Colors.grey : Colors.blue,
          ),
          child: Text(letter),
        );
      }).toList(),
    );
  }
}
