import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_logic.dart';

class ScoreText extends TextComponent with HasGameRef<FlutterBird> {
  ScoreText()
      : super(
    text: '0',
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
  }

  @override
  void update(double dt) {
    super.update(dt);
    final newText = gameRef.score.toString();
    if (text != newText) {
      text = newText;
    }
  }
}
