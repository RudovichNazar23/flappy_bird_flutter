import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutterbird/game_logic.dart';
import 'dart:async';
import '../constants.dart';

class Grass extends SpriteComponent with CollisionCallbacks, HasGameRef<FlutterBird> {
  Grass(Vector2 position, Vector2 size)
      : super(position: position, size: size, priority: 1);

  @override
  FutureOr<void> onLoad() async{
    sprite = await Sprite.load('grass.png');

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= groundSpeed * dt;
    if(position.x + size.x <= 0){
      removeFromParent();
    }
  }
}