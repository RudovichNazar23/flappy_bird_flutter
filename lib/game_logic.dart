import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutterbird/components/bird.dart';
import 'package:flutterbird/components/score.dart';
import 'components/background.dart';
import 'components/ground.dart';
import 'components/pipe.dart';
import 'components/pipe_manager.dart';
import 'constants.dart';
import 'main.dart';
import 'components/startmenu.dart';
import 'components/timer_text.dart'; // Import TimerText
import 'components/stars.dart' show Stars;
import 'components/item_manager.dart' show ItemManager;
import 'constants.dart';
import 'main.dart';


class FlutterBird extends FlameGame with TapDetector, HasCollisionDetection, KeyboardEvents {
  final String playerName;
  late Bird bird;
  late Background background;
  late Stars stars;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  late ItemManager rock;
  late ItemManager bush;
  late ItemManager grass;
  late TimerText timerText;
  final double groundSpeed;
  final double pipeSpawnDistance;

  double remainingTime = 60.0;
  double timeSurvived = 0.0;
  bool isGameOver = false;
  int score = 0;

  FlutterBird({required this.groundSpeed, required this.playerName, required this.pipeSpawnDistance});

  @override
  Future<void> onLoad() async {
    background = Background(size);
    add(background);

    stars = Stars(size);
    add(stars);

    bird = Bird();
    add(bird);

    ground = Ground();
    add(ground);

    rock = ItemManager('rock.png');
    add(rock);

    bush = ItemManager('bush.png');
    add(bush);

    grass = ItemManager('grass.png');
    add(grass);

    pipeManager = PipeManager();
    add(pipeManager);

    scoreText = ScoreText(playerName: playerName);
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

        timerText.text = 'Time: ${remainingTime.toStringAsFixed(1)}';
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
    scoreText.updateScore(score);
  }

  void gameOver() {
    if (isGameOver) return;

    isGameOver = true;
    pauseEngine();


    String dialogTitle = remainingTime <= 0 && timeSurvived >= 60.0 ? 'Congratulations!' : 'Game Over';
    String dialogMessage = remainingTime <= 0 && timeSurvived >= 60.0
        ? 'You completed the game!'
        : 'Player: $playerName\nScore: $score\nTime: ${timeSurvived.toStringAsFixed(1)}';

    showDialog(
      context: buildContext!,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: PixelContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Game Over',
                  style: const TextStyle(
                    fontSize: 48,
                    fontFamily: "PixelFont",
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF9FBF2),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  dialogMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'PixelFont',
                    fontSize: 32,
                    color: Color(0xFFE9C46A),
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
