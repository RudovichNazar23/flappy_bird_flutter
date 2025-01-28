import 'package:flame/components.dart';
import 'package:flutter/material.dart'; // Dodano brakujący import
import '../game_logic.dart';

class ScoreText extends TextComponent with HasGameRef<FlutterBird> {
  final String playerName;

  ScoreText({required this.playerName})
      : super(
    text: '',
    textRenderer: TextPaint(
      style: const TextStyle(
        fontFamily: 'PixelFont',
        color: Colors.black,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.topCenter;
    position = Vector2(gameRef.size.x / 2, 50);
    priority = 10;
    updateScore(gameRef.score);
  }

  void updateScore(int score) {
    text = '$playerName: $score';
  }
}
