import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_logic.dart';

class TimerText extends TextComponent with HasGameRef<FlutterBird> {
  Vector2 _lastSize = Vector2.zero();

  TimerText()
      : super(
    text: 'Time: 60.0s',
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 36,
        fontFamily: 'PixelFont',
      ),
    ),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.bottomCenter;
    _updatePosition(gameRef.size);
  }

  @override
  void update(double dt) {
    super.update(dt);


    if (_lastSize.x != gameRef.size.x || _lastSize.y != gameRef.size.y) {
      _updatePosition(gameRef.size);
      _lastSize = gameRef.size.clone();
    }

    final remainingTime = (gameRef.remainingTime * 100).ceil() / 100.0;
    text = remainingTime > 0
        ? 'Time: ${remainingTime.toStringAsFixed(1)}'
        : 'Time: 0.0';
  }

  void _updatePosition(Vector2 newSize) {
    position = Vector2(newSize.x / 2, newSize.y - 20);
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    _updatePosition(newSize);
  }
}