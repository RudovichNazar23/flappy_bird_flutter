import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbird/components/bird.dart';
import 'package:flutterbird/components/score.dart';
import 'components/background.dart';
import 'components/ground.dart';
import 'components/pipe.dart';
import 'components/pipe_manager.dart';
import 'components/timer_text.dart'; // Import TimerText
import 'constants.dart';
import 'main.dart';
import 'components/startmenu.dart';

class FlutterBird extends FlameGame with TapDetector, HasCollisionDetection, KeyboardEvents {
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  late TimerText timerText;

  double remainingTime = 60.0;
  double timeSurvived = 0.0;
  bool isGameOver = false;
  int score = 0;

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

    timerText = TimerText();
    add(timerText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isGameOver) {
      if (remainingTime > 0) {
        remainingTime -= dt;
        timeSurvived += dt;
        if (remainingTime <= 0) {
          remainingTime = 0;
          gameOver();
        }
      }
    }
  }

  @override
  void onTap() {
    if (!isGameOver) {
      bird.flap();
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    if (!isGameOver && event is KeyDownEvent && keys.contains(LogicalKeyboardKey.space)) {
      bird.flap();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void incrementScore() {
    score += 1;
  }

  void gameOver() {
    if (isGameOver) return;

    isGameOver = true;
    pauseEngine();


    String dialogTitle = remainingTime <= 0 && timeSurvived >= 60.0 ? 'Congratulations!' : 'Game Over';
    String dialogMessage = remainingTime <= 0 && timeSurvived >= 60.0
        ? 'You completed the game!'
        : 'Score: $score\nTime: ${timeSurvived.toStringAsFixed(1)}';

    showDialog(
      context: buildContext!,
      barrierDismissible: false,
      builder: (context) {
        return AnimatedOpacity(
          opacity: isGameOver ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: PixelContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dialogTitle,
                    style: const TextStyle(
                      fontSize: 48,
                      fontFamily: "PixelFont",
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dialogMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'PixelFont',
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  PixelButton(
                    text: 'Restart',
                    onPressed: () {
                      Navigator.pop(context);
                      resetGame();
                    },
                  ),
                  const SizedBox(height: 10),
                  PixelButton(
                    text: 'Game Menu',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void resetGame() {
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;

    score = 0;
    remainingTime = 60.0;
    timeSurvived = 0.0;
    isGameOver = false;

    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());

    timerText.text = 'Time: 60.0s';

    resumeEngine();
  }
}
