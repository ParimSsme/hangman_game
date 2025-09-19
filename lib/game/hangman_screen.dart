import 'package:flutter/material.dart';
import 'package:hangman/theme/app_text_styles.dart';
import '../theme/app_colors.dart';
import 'hangman_game.dart';
import '../animations/win/hangman_win_animation.dart';
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
      duration: const Duration(seconds: 3),
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
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "😢 Game Over",
            style: TextStyle(color: Colors.redAccent),
          ),
          content: Text(
            "The word was: ${_game.word.toUpperCase()}",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Play Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
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
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "🎉 You Win!",
            style: TextStyle(color: Colors.greenAccent),
          ),
          content: Text(
            "Great job! The word was: ${_game.word.toUpperCase()}",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Play Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
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
      _winController.reset();
      _loseController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                        child: _game.isGameOver && !_game.isWinner
                            ? HangmanLoseAnimation(
                                animation: _loseController,
                                gallows: CustomPaint(
                                  size: const Size(200, 250),
                                  painter: GallowsPainter(),
                                ),
                                stickman: _game.buildStickmanOnly(),
                              )
                            : _game.isGameOver && _game.isWinner
                                ? HangmanWinAnimation(
                                    animation: _winController,
                                    child: _game.buildStickman(),
                                  )
                                : _game.buildStickman(),
                      ),

                      WordDisplay(
                          word: _game.word, guessed: _game.guessedLetters),

                      Card(
                        color: AppColors.card,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
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
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
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
                                  text: '${_game.incorrectGuesses} / ${_game.maxGuesses}',
                                  style: AppTextStyles.headingMedium.copyWith(
                                    color: AppColors.red,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center, // aligns the whole text
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
      ),
    );
  }
}
