import 'package:flutter/material.dart';
import 'package:hangman/theme/app_text_styles.dart';
import '../animations/win/confetti_painter.dart';
import '../theme/app_colors.dart';
import 'hangman_game.dart';
import '../animations/lose/hangman_lose_animation.dart';
import '../widgets/keyboard.dart';
import '../widgets/word_display.dart';
import 'hangman_painter.dart';

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
      duration: const Duration(seconds: 5), // slower
    )..repeat();
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
          _winController.forward(from: 0);

          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) return;
            _showWinDialog();
          });
        } else {
          _loseController.forward(from: 0);

          Future.delayed(const Duration(milliseconds: 600), () {
            if (!mounted) return;
            _showGameOverDialog();
          });
        }
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Column(
            children: [
              const Text(
                "😢",
                style: TextStyle(fontSize: 95),
              ),
              Text(
                "Game Over",
                style: AppTextStyles.headingLarge.copyWith(fontSize: 25),
              ),
            ],
          ),
          content: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "The correct word was:\n",
                  style: AppTextStyles.bodySmall,
                ),
                TextSpan(
                  text: _game.word,
                  style: AppTextStyles.headingMedium,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _resetGame();
                  },
                  child: const Text("PLAY AGAIN"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Column(
            children: [
              const Text(
                "🎉",
                style: TextStyle(fontSize: 95),
              ),
              Text(
                "You Win!",
                style: AppTextStyles.headingLarge.copyWith(fontSize: 25),
              ),
            ],
          ),
          content: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Great job! The word was:\n",
                  style: AppTextStyles.bodySmall,
                ),
                TextSpan(
                  text: _game.word,
                  style: AppTextStyles.headingMedium,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _resetGame();
                  },
                  child: const Text("PLAY AGAIN"),
                ),
              ],
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
    return Scaffold(
      backgroundColor: _game.isGameOver && !_game.isWinner
          ? Colors.red.shade900
          : Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            /// Main game UI
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                color: _game.isGameOver && !_game.isWinner
                    ? Colors.red.shade900
                    : Colors.white,
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
                              padding:
                              const EdgeInsets.symmetric(horizontal: 60.0),
                              child: _game.isGameOver && !_game.isWinner
                                  ? HangmanLoseAnimation(
                                animation: _loseController,
                                gallows: CustomPaint(
                                  size: const Size(
                                      double.infinity, double.infinity),
                                  painter: GallowsPainter(),
                                ),
                                stickman: _game.buildStickmanOnly(),
                              )
                                  : _game.isGameOver && _game.isWinner
                                  ? _game.buildStickman()
                                  : _game.buildStickman(),
                            ),
                          ),
                          WordDisplay(
                            word: _game.word,
                            guessed: _game.guessedLetters,
                          ),
                          Card(
                            color: AppColors.card,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 5),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Hint: ",
                                      style: AppTextStyles.headingMedium.copyWith(
                                        color: AppColors.blue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _game.hint,
                                      style: AppTextStyles.headlineSmall.copyWith(
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ),
                          ),
                          Card(
                            color: AppColors.card,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 5),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Incorrect guesses: ",
                                      style: AppTextStyles.headingMedium.copyWith(
                                        color: AppColors.blue,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                      '${_game.incorrectGuesses} / ${_game.maxGuesses}',
                                      style: AppTextStyles.headingMedium.copyWith(
                                        color: AppColors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Keyboard(onTap: _onLetterTap, disabled: _game.guessedLetters),
                  ],
                ),
              ),
            ),

            /// Full screen confetti when winning
            if (_game.isGameOver && _game.isWinner)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _winController,
                    builder: (context, _) {
                      return CustomPaint(
                        size: Size(double.infinity, double.infinity),
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
}
