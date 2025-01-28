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
import 'constants.dart';
import 'main.dart';
import 'components/startmenu.dart';

class FlutterBird extends FlameGame with TapDetector, HasCollisionDetection, KeyboardEvents {
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  final double groundSpeed;

  FlutterBird({required this.groundSpeed});

  @override
  Future<void> onLoad() async {
    background = Background();
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

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    if (event is KeyDownEvent && keys.contains(LogicalKeyboardKey.space)) {
      bird.flap();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: buildContext!,
        barrierDismissible: false,
        builder: (context) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;
          double fontSize = (screenWidth + screenHeight) * 0.025;
          double buttonWidth = screenWidth * 0.6;
          double buttonHeight = screenHeight * 0.08;

          return AnimatedOpacity(
            opacity: isGameOver ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                child: PixelContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Game Over',
                        style: TextStyle(
                          fontSize: fontSize * 1.5,
                          fontFamily: "PixelFont",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF9FBF2),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Score: $score',
                        style: TextStyle(
                          fontFamily: 'PixelFont',
                          fontSize: fontSize,
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
                        fontSize: fontSize,
                        buttonWidth: buttonWidth,
                        buttonHeight: buttonHeight,
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
                        fontSize: fontSize,
                        buttonWidth: buttonWidth,
                        buttonHeight: buttonHeight,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
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

class PixelButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double fontSize;
  final double buttonWidth;
  final double buttonHeight;

  const PixelButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.fontSize,
    required this.buttonWidth,
    required this.buttonHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.05; // 5% of screen width

    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Container(
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(
              color: Colors.black,
              width: 5.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                offset: const Offset(6, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'PixelFont',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}