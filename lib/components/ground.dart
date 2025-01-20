import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutterbird/constants.dart';
import 'package:flutterbird/game_logic.dart';

class Ground extends SpriteComponent with HasGameRef<FlutterBird>, CollisionCallbacks{
  Ground() : super();

  @override
  FutureOr<void> onLoad() async{
    size = Vector2(2 * gameRef.size.x, groundHeight);
    position = Vector2(0, gameRef.size.y - groundHeight);

    sprite = await Sprite.load('base.png');

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= groundSpeed * dt;
    if(position.x + size.x /2 < 0){
      position.x = 0;
    }
  }
}