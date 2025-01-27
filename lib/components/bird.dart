import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutterbird/components/pipe.dart';
import 'dart:async';
import 'package:flutterbird/constants.dart';
import 'package:flutterbird/game_logic.dart';
import 'ground.dart';

class Bird extends SpriteComponent with CollisionCallbacks {
  Bird() : super(position: Vector2(birdStartX, birdStartY), size: Vector2(birdwidth, birdheight));

  double velocity = 0;
  late Sprite rocketModel;


  @override
  FutureOr<void> onLoad() async {
    rocketModel = await Sprite.load('astronaut.png');
    sprite = rocketModel;

    add(RectangleHitbox());
  }

  void flap() {
    velocity = jumpStrength;
  }

  @override
  void update(double dt) {
    velocity += gravity * dt;
    position.y += velocity * dt;

  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Ground) {
      (parent as FlutterBird).gameOver();
    }
    if (other is Pipe) {
      (parent as FlutterBird).gameOver();
    }
  }
}