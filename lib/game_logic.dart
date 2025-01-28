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

class FlutterBird extends FlameGame with TapDetector, HasCollisionDetection, KeyboardEvents {
  late final String playerName;
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  late final double groundSpeed;
  final ValueNotifier<Size> resolutionNotifier;
  bool _isShowingGameOver = false;

  FlutterBird({
    required this.groundSpeed,
    required this.playerName,
    required this.resolutionNotifier
  }) {
    resolutionNotifier.addListener(_onResolutionChanged);
  }

  int score = 0;
  bool isGameOver = false;

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

    scoreText = ScoreText(playerName: playerName);
    add(scoreText);
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
    if (isGameOver || _isShowingGameOver) return;

    isGameOver = true;
    _isShowingGameOver = true;
    pauseEngine();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (buildContext != null) {
        showDialog(
          context: buildContext!,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent[200],
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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Game Over',
                        style: TextStyle(
                          fontSize: 48,
                          fontFamily: 'PixelFont',
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
                      GameOverButton(
                        text: 'Restart',
                        onPressed: () {
                          Navigator.pop(context);
                          _isShowingGameOver = false;
                          resetGame();
                        },
                      ),
                      const SizedBox(height: 10),
                      GameOverButton(
                        text: 'Game Menu',
                        onPressed: () {
                          Navigator.pop(context);
                          _isShowingGameOver = false;
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
        ).then((_) {
          _isShowingGameOver = false;
        });
      }
    });
  }

  void resetGame() {
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;

    score = 0;
    isGameOver = false;
    _isShowingGameOver = false;

    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());

    resumeEngine();
  }

  void _onResolutionChanged() {
    if (!hasLayout) return;

    final newSize = Vector2(
        resolutionNotifier.value.width,
        resolutionNotifier.value.height
    );

    background.size = newSize;
    ground.size = newSize;
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
  }

  @override
  void onRemove() {
    resolutionNotifier.removeListener(_onResolutionChanged);
    super.onRemove();
  }
}

class GameOverButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const GameOverButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<GameOverButton> createState() => _GameOverButtonState();
}

class _GameOverButtonState extends State<GameOverButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            color: _isPressed
                ? Colors.purple[900]
                : _isHovered
                ? Colors.purple[700]
                : Colors.purple,
            border: Border.all(
              color: Colors.black,
              width: 5.0,
            ),
            boxShadow: _isPressed
                ? []
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                offset: const Offset(6, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontFamily: 'PixelFont',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}