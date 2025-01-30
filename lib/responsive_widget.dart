import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Background extends Component {
  late SpriteComponent mountains;
  late SpriteComponent stars;
  late Paint backgroundPaint;

  Background() {
    mountains = SpriteComponent();
    stars = SpriteComponent();

    backgroundPaint = BasicPalette.blue.paint()
      ..color = const Color(0xFF1560BD);
  }

  @override
  Future<void> onLoad() async {
    mountains.sprite = await Sprite.load('mountains.png');
    stars.sprite = await Sprite.load('green-stars.png');
  }

  @override
  void render(Canvas canvas) {
    // Draw the blue background
    canvas.drawRect(Rect.fromLTWH(0, 0, mountains.size.x, mountains.size.y * 2), backgroundPaint);

    // Draw the mountains
    mountains.render(canvas);

    // Draw the stars
    stars.render(canvas);
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    mountains.size = Vector2(newSize.x, newSize.y / 2);
    mountains.position = Vector2(0, newSize.y / 2);
    stars.size = newSize;
  }
}