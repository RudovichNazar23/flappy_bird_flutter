import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_logic.dart';

class ScoreText extends PositionComponent with HasGameRef<FlutterBird> {
  final String playerName;
  late TextComponent _nameComponent;
  late TextComponent _scoreComponent;
  late RectangleComponent _backgroundBox;
  Vector2 _lastSize = Vector2.zero();
  int _score = 0;

  ScoreText({required this.playerName}) : super(priority: 10);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _backgroundBox = RectangleComponent(
      size: Vector2(260, 70),
      paint: Paint()..color = const Color(0xFF0A2540),
    )..priority = -1;

    _nameComponent = TextComponent(
      text: playerName,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontFamily: 'PixelFont',
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.centerLeft,
    );

    _scoreComponent = TextComponent(
      text: '0',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontFamily: 'PixelFont',
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.centerRight,
    );

    add(_backgroundBox);
    add(_nameComponent);
    add(_scoreComponent);

    _updatePosition(gameRef.size);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_lastSize != gameRef.size) {
      _updatePosition(gameRef.size);
      _lastSize = gameRef.size.clone();
    }
  }

  void _updatePosition(Vector2 newSize) {
    position = Vector2(15, newSize.y - 85);

    _backgroundBox.position = Vector2.zero();

    _nameComponent.position = Vector2(20, _backgroundBox.size.y / 2);
    _scoreComponent.position = Vector2(_backgroundBox.size.x - 20, _backgroundBox.size.y / 2);
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    _updatePosition(newSize);
  }

  void updateScore(int score) {
    _score = score;
    _scoreComponent.text = '$_score';
  }
}
