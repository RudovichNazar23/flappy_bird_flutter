import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutterbird/game_logic.dart';
import 'dart:async';
import '../constants.dart';

class Pipe extends SpriteComponent with CollisionCallbacks, HasGameRef<FlutterBird> {
final bool isTopPipe;
bool scored = false;

Pipe(Vector2 position, Vector2 size, {required this.isTopPipe})
    : super(position: position, size: size);

@override
  FutureOr<void> onLoad() async{
    sprite = await Sprite.load(isTopPipe ? 'pipe-top.png' : 'pipe-bottom.png');

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= groundSpeed * dt;

    if (!scored && position.x + size.x < gameRef.bird.position.x) {
      scored = true;
      if (isTopPipe) {
        gameRef.incrementScore();
      }
    }


    if(position.x + size.x <= 0){
      removeFromParent();
    }
  }
}