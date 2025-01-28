import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../game_logic.dart';

class Background extends SpriteComponent with HasGameRef<FlutterBird> {
  Background()
      : super(
    position: Vector2(0, 0),
  );

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('background.png');
    size = gameRef.size; // Set the background size to the screen size
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    size = newSize; // Update the size when the game resizes
  }
}