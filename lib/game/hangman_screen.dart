import 'package:flutter/material.dart';
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
  bool showHint = false;

  @override
  void initState() {
    super.initState();
    _game = HangmanGame();
    _winController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _loseController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  void _onLetterTap(String letter) {
    setState(() {
      _game.guessLetter(letter);

      if (_game.isGameOver) {
        if (_game.isWinner) {
          _winController.forward(from: 0);
        } else {
          _loseController.forward(from: 0);
          Future.delayed(const Duration(milliseconds: 600), () {
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


  void _resetGame() {
    setState(() {
      _game.reset();
      _winController.reset();
      _loseController.reset();
      showHint = false;
    });
  }

  void _revealHint() {
    if (!_game.usedHint) {
      setState(() {
        showHint = true;
        _game.usedHint = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hangman")),
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        color: _game.isGameOver && !_game.isWinner
            ? Colors.red.shade900
            : Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    _game.isGameOver && !_game.isWinner
                        ? HangmanLoseAnimation(
                      animation: _loseController,
                      gallows: CustomPaint(size: const Size(200, 250), painter: GallowsPainter()),
                      stickman: _game.buildStickmanOnly(),
                    )
                        : _game.isGameOver && _game.isWinner
                        ? HangmanWinAnimation(animation: _winController, child: _game.buildStickman())
                        : _game.buildStickman(),

                    const SizedBox(height: 16),

                    Text(
                      "Incorrect guesses: ${_game.incorrectGuesses} / ${_game.maxGuesses}",
                      style: const TextStyle(fontSize: 18, color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
            ),

            WordDisplay(word: _game.word, guessed: _game.guessedLetters),

            if (showHint)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "💡 Hint: ${_game.hint}",
                  style: const TextStyle(fontSize: 18, color: Colors.yellow),
                  textAlign: TextAlign.center,
                ),
              ),

            if (!_game.isGameOver && !_game.usedHint)
              ElevatedButton(
                onPressed: _revealHint,
                child: const Text("Show Hint"),
              ),

            Keyboard(onTap: _onLetterTap, disabled: _game.guessedLetters),

            if (_game.isGameOver)
              ElevatedButton(
                onPressed: _resetGame,
                child: const Text("Play Again"),
              ),
          ],
        ),
      ),
    );
  }


}

