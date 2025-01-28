import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutterbird/game_logic.dart';
import 'dart:async';
import '../constants.dart';

class Item extends SpriteComponent with CollisionCallbacks, HasGameRef<FlutterBird> {
  final String imageName;

  Item(Vector2 position, Vector2 size, this.imageName)
      : super(position: position, size: size, priority: 1);

  @override
  FutureOr<void> onLoad() async{
    sprite = await Sprite.load(imageName);

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