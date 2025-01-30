// score.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_logic.dart';

class ScoreText extends TextComponent with HasGameRef<FlutterBird> {
  final String playerName;
  Vector2 _lastSize = Vector2.zero();

  ScoreText({required this.playerName})
      : super(
    text: '',
    textRenderer: TextPaint(
      style: const TextStyle(
        fontFamily: 'PixelFont',
        color: Colors.white,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.topCenter;
    _updatePosition(gameRef.size);
    priority = 10;
    updateScore(gameRef.score);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Sprawdź zmianę rozmiaru
    if (_lastSize.x != gameRef.size.x || _lastSize.y != gameRef.size.y) {
      _updatePosition(gameRef.size);
      _lastSize = gameRef.size.clone();
    }
  }

  void _updatePosition(Vector2 newSize) {
    position = Vector2(newSize.x / 2, 50);
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    _updatePosition(newSize);
  }

  void updateScore(int score) {
    text = '$playerName: $score';
  }
}