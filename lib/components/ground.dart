import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutterbird/constants.dart';
import 'package:flutterbird/game_logic.dart';
import 'package:flutter/material.dart';

class Ground extends PositionComponent with HasGameRef<FlutterBird>, CollisionCallbacks {
  Ground() : super();
  @override
  FutureOr<void> onLoad() async {
    size = Vector2(2 * gameRef.size.x, groundHeight);
    position = Vector2(0, gameRef.size.y - groundHeight);
    add(RectangleHitbox());
  }
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.black;
    canvas.drawRect(size.toRect(), paint);
  }
  @override
  void update(double dt) {
    super.update(dt);
    position.x -= groundSpeed * dt;
    if (position.x + size.x / 2 < 0) {
      position.x = 0;
    }
  }
}

