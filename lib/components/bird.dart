import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:galacticglide/components/pipe.dart';
import 'dart:async';
import 'package:galacticglide/constants.dart';
import 'package:galacticglide/game_logic.dart';
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


    if (position.y <= 0) {
      position.y = 0;
      (parent as FlutterBird).gameOver();
    }
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
