import 'package:flutter/material.dart';
import 'package:hangman/theme/app_text_styles.dart';
import '../animations/win/confetti_painter.dart';
import '../theme/app_colors.dart';
import 'hangman_game.dart';
import '../animations/lose/hangman_lose_animation.dart';
import '../widgets/keyboard.dart';
import '../widgets/word_display.dart';
import 'hangman_painter.dart';
import 'dart:async';

class HangmanScreen extends StatefulWidget {
  const HangmanScreen({super.key});

  @override
  State<HangmanScreen> createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen>
    with TickerProviderStateMixin {
  late HangmanGame _game;
  late AnimationController _winController;
  late AnimationController _loseController;

  @override
  void initState() {
    super.initState();
    _game = HangmanGame();

    _winController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _loseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  void _onLetterTap(String letter) {
    setState(() {
      _game.guessLetter(letter);

      if (_game.isGameOver) {
        if (_game.isWinner) {
          _winController.repeat();

          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) return;
            _showDialog(
              emoji: "🎉",
              title: "You Win!",
              message: "Great job! The word was:\n${_game.word}",
            );
          });
        } else {
          _loseController.forward(from: 0);

          Future.delayed(const Duration(milliseconds: 600), () {
            if (!mounted) return;
            _showDialog(
              emoji: "😢",
              title: "Game Over",
              message: "The correct word was:\n${_game.word}",
            );
          });
        }
      }
    });
  }

  void _showDialog({
    required String emoji,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 95)),
              Text(
                title,
                style: AppTextStyles.headingLarge.copyWith(fontSize: 25),
              ),
            ],
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetGame();
                },
                child: const Text("PLAY AGAIN"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _game.reset();
      _winController.stop();
      _winController.reset();
      _loseController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLose = _game.isGameOver && !_game.isWinner;
    final isWin = _game.isGameOver && _game.isWinner;

    return Scaffold(
      backgroundColor: isLose ? Colors.red.shade900 : Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            /// Main game UI
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                color: isLose ? Colors.red.shade900 : Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 30,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 15,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 60),
                              child: isLose
                                  ? HangmanLoseAnimation(
                                animation: _loseController,
                                gallows: CustomPaint(
                                  size: const Size(
                                    double.infinity,
                                    double.infinity,
                                  ),
                                  painter: GallowsPainter(),
                                ),
                                stickman: _game.buildStickmanOnly(),
                              )
                                  : _game.buildStickman(),
                            ),
                          ),
                          WordDisplay(
                            word: _game.word,
                            guessed: _game.guessedLetters,
                          ),
                          _buildInfoCard(
                            label: "Hint:",
                            value: _game.hint,
                            valueStyle: AppTextStyles.headlineSmall
                                .copyWith(color: AppColors.black),
                          ),
                          _buildInfoCard(
                            label: "Incorrect guesses:",
                            value:
                            "${_game.incorrectGuesses} / ${_game.maxGuesses}",
                            valueStyle: AppTextStyles.headingMedium
                                .copyWith(color: AppColors.red),
                          ),
                        ],
                      ),
                    ),
                    Keyboard(
                      onTap: _onLetterTap,
                      disabled: _game.guessedLetters,
                    ),
                  ],
                ),
              ),
            ),

            /// Full screen confetti when winning
            if (isWin)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _winController,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: ConfettiPainter(_winController.value),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    required TextStyle valueStyle,
  }) {
    return Card(
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "$label ",
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.blue,
                ),
              ),
              TextSpan(text: value, style: valueStyle),
            ],
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ),
    );
  }
}

