import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_logic.dart';
import 'dart:async';

class ScoreText extends TextComponent with HasGameRef<FlutterBird> {
  ScoreText()
      : super(
    text: '0',
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Colors.green,
        fontSize: 36,
      ),
    ),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.topCenter;
    position = Vector2(gameRef.size.x / 2, 50); // Wyśrodkowane nad górą ekranu
  }



  @override
  void update(double dt) {
    super.update(dt); // Pamiętaj o wywołaniu super.update(dt)
    final newText = gameRef.score.toString();
    if (text != newText) {
      text = newText;
    }
  }
}
