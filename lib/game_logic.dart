import 'dart:io';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'components/background.dart';
import 'components/bird.dart';
import 'components/ground.dart';
import 'components/item_manager.dart';
import 'components/pipe_manager.dart';
import 'components/pipe.dart';
import 'constants.dart';
import 'main.dart';

class FlutterBird extends FlameGame with TapDetector, HasCollisionDetection, KeyboardEvents {
  final String playerName;
  final VoidCallback? onRestart;
  final VoidCallback? onGameOver;
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ItemManager rock;
  late ItemManager bush;
  late ItemManager grass;
  final double groundSpeed;
  final double pipeSpawnDistance;

  double remainingTime = 60.0;
  double timeSurvived = 0.0;
  bool isGameOver = false;
  int score = 0;

  final ValueNotifier<String> hoveredButton = ValueNotifier('');

  FlutterBird({
    required this.groundSpeed,
    required this.playerName,
    required this.pipeSpawnDistance,
    this.onRestart,
    this.onGameOver,
  });

  String _formatTime(double timeInSeconds) {
    int totalSeconds = timeInSeconds.round();
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void updateRemainingTime(double time) {
    remainingTime = time;
    if (time <= 0 && !isGameOver) {
      gameOver();
    }
  }

  @override
  Future<void> onLoad() async {
    background = Background(size);
    add(background);

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
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isGameOver) {
      timeSurvived += dt;
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
    onGameOver?.call();

    bool hasWon = remainingTime <= 0 && timeSurvived >= 60.0;
    String dialogTitle = hasWon ? 'Congratulations!' : 'Game Over';
    String dialogMessage = hasWon
        ? 'Congratulations ${playerName}!\nYou survived for ${_formatTime(timeSurvived)}!'
        : 'Player: $playerName\nScore: $score\nTime: ${_formatTime(timeSurvived)}';

    showDialog(
      context: buildContext!,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: hasWon ? const Color(0xFF1be2bc) : Colors.blueAccent[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dialogTitle,
                    style: TextStyle(
                      fontSize: 48,
                      fontFamily: "PixelFont",
                      fontWeight: FontWeight.bold,
                      color: hasWon ? Colors.black : const Color(0xFFF9FBF2),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dialogMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildGameOverButton(
                    text: 'Restart',
                    onPressed: () {
                      Navigator.pop(context);
                      resetGame();
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildGameOverButton(
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

  Widget _buildGameOverButton({required String text, required VoidCallback onPressed}) {
    return ValueListenableBuilder<String>(
      valueListenable: hoveredButton,
      builder: (context, hovered, child) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => hoveredButton.value = text,
          onExit: (_) => hoveredButton.value = '',
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 210,
              height: 60,
              decoration: BoxDecoration(
                color: hovered == text ? const Color(0xFF15caa8) : const Color(0xFF1be2bc),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
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

    onRestart?.call();
    resumeEngine();
  }
}

