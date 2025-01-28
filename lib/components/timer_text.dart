import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_logic.dart';

class TimerText extends TextComponent with HasGameRef<FlutterBird> {
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
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 20);
  }

  @override
  void update(double dt) {
    super.update(dt);


    final remainingTime = (gameRef.remainingTime * 100).ceil() / 100.0;
    text = remainingTime > 0
        ? 'Time: ${remainingTime.toStringAsFixed(1)}'
        : 'Time: 0.0';
  }
}
