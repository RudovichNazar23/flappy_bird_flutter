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
import 'components/stars.dart' show Stars;
import 'components/item_manager.dart' show ItemManager;


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
  final double groundSpeed;
  final double pipeSpawnDistance;

  FlutterBird({required this.groundSpeed, required this.playerName, required this.pipeSpawnDistance});

  int score = 0;
  bool isGameOver = false;

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

    // Score Text
    scoreText = ScoreText(playerName: playerName);
    add(scoreText);
  }

  @override
  void onTap() {
    bird.flap();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {

    if (event is KeyDownEvent && keys.contains(LogicalKeyboardKey.space)) {
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
                  'Player: $playerName\nScore: $score',
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
    isGameOver = false;

    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());

    resumeEngine();
  }
}
