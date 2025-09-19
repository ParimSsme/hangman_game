import 'package:flutter/material.dart';
import 'hangman_painter.dart';

class HangmanGame {
  late String word;
  late String hint;
  final Set<String> guessedLetters = {};
  int remainingAttempts = 6;
  bool usedHint = false;

  HangmanGame() {
    reset();
  }

  void reset() {
    final words = [
      {"word": "flutter", "hint": "A UI framework by Google"},
      {"word": "widget", "hint": "The building block of Flutter UI"},
      {"word": "state", "hint": "Something widgets can manage"},
      {"word": "dart", "hint": "Programming language for Flutter"},
    ];

    words.shuffle();
    final chosen = words.first;

    word = chosen["word"]!;
    hint = chosen["hint"]!;
    guessedLetters.clear();
    remainingAttempts = 6;
    usedHint = false;
  }

  void guessLetter(String letter) {
    if (guessedLetters.contains(letter) || isGameOver) return;

    guessedLetters.add(letter);

    if (!word.contains(letter)) {
      remainingAttempts--;
    }
  }


  bool get isWinner => word.split("").every(guessedLetters.contains);
  bool get isGameOver => isWinner || remainingAttempts == 0;

  int get incorrectGuesses => 6 - remainingAttempts;
  int get maxGuesses => 6;

  Widget buildStickman() {
    return SizedBox(
      width: 200,
      height: 250,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          CustomPaint(size: const Size(200, 250), painter: GallowsPainter()),
          CustomPaint(size: const Size(200, 250), painter: StickmanPainter(incorrectGuesses)),
        ],
      ),
    );
  }

  Widget buildStickmanOnly() {
    return CustomPaint(
      size: const Size(200, 250),
      painter: StickmanPainter(incorrectGuesses),
    );
  }
}


