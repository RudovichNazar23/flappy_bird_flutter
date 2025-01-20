import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_logic.dart';
import 'dart:async';

class ScoreText extends TextComponent with HasGameRef<FlutterBird> {
  ScoreText()
      : super(
    text: '0',
    textRenderer: TextPaint(
      style: TextStyle(
          color: Colors.green,
        fontSize: 36,
      ),
      ),
    );

  @override
  FutureOr<void> onLoad() {
    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      gameRef.size.y - size.y - 50,
    );
  }
    void update(double dt) {
      final newText = gameRef.score.toString();
      if (text != newText) {
        text = newText;
      }
    }
  }