import 'package:flutter/material.dart';

class WordDisplay extends StatelessWidget {
  final String word;
  final Set<String> guessed;

  const WordDisplay({super.key, required this.word, required this.guessed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: word.split("").map((char) {
        final isGuessed = guessed.contains(char);
        return Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            isGuessed ? char : "_",
            style: const TextStyle(fontSize: 32, letterSpacing: 4),
          ),
        );
      }).toList(),
    );
  }
}
