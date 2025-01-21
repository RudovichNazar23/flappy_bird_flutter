import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutterbird/components/bird.dart';
import 'package:flutterbird/components/score.dart';
import 'package:flutterbird/components/startmenu.dart';
import 'components/background.dart';
import 'components/ground.dart';
import 'components/pipe.dart';
import 'components/pipe_manager.dart';
import 'constants.dart';
import 'main.dart';
class FlutterBird extends FlameGame with TapDetector, HasCollisionDetection {


  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;

  @override
  Future<void> onLoad() async {
    background = Background(size);
    add(background);

    bird = Bird();
    add(bird);

    ground = Ground();
    add(ground);

    pipeManager = PipeManager();
    add(pipeManager);

    scoreText = ScoreText();
    add(scoreText);
  }

  @override
  void onTap() {
    bird.flap();
  }

  int score = 0;

  void incrementScore() {
    score += 1;
  }

  bool isGameOver = false;

  void gameOver() {
    if (isGameOver) return;

    isGameOver = true;
    pauseEngine();

    // Show a custom dialog with animation
    showDialog(
      context: buildContext!,
      barrierDismissible: false,  // Prevent dismissing the dialog by tapping outside
      builder: (context) {
        return AnimatedOpacity(
          opacity: isGameOver ? 1.0 : 0.0, // Control opacity to create fade-in effect
          duration: const Duration(milliseconds: 500), // Duration of the fade-in
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              child:PixelContainer(child:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Game Over',
                      style: TextStyle(
                        fontSize: 48,
                        fontFamily: "PixelFont",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF9FBF2),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Score: $score',
                      style: const TextStyle(
                        fontFamily: 'PixelFont',
                        fontSize: 32,
                        color: Color(0xFFE9C46A),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PixelButton(text: 'Restart', onPressed: () {
                        Navigator.pop(context);
                        resetGame();
                      },
                    ),
                    const SizedBox(height: 10),
                    PixelButton(text: 'Game Menu', onPressed:(){
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    },
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              )
            ),
          ),
        );
      },
    );
  }

  void resetGame() {
    // Make sure the bird's position and velocity are properly reset
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;

    // Reset the score and game-over state
    score = 0;
    isGameOver = false;

    // Remove all pipes from the game
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());

    // Resume the game engine
    resumeEngine();
  }
}

