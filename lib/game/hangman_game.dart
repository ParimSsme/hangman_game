import 'package:flutter/material.dart';
import 'package:hangman/game/word_list.dart';
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

    wordList.shuffle();
    final chosen = wordList.first;

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            CustomPaint(size: const Size(double.infinity, double.infinity), painter: GallowsPainter()),
            CustomPaint(size: const Size(double.infinity, double.infinity), painter: StickmanPainter(incorrectGuesses)),
          ],
        ),
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


