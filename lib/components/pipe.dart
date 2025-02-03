import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:galacticglide/game_logic.dart';
import 'dart:async';
import '../constants.dart';

class Pipe extends SpriteComponent with CollisionCallbacks, HasGameRef<FlutterBird> {
  final bool isTopPipe;
  bool _passed = false;

  Pipe(Vector2 position, Vector2 size, {required this.isTopPipe})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(isTopPipe ? 'pipe-top.png' : 'pipe-bottom.png');
    add(RectangleHitbox());
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    if (!isTopPipe) {
      position.y = newSize.y - groundHeight - size.y;
    }
  }

  @override
  void update(double dt) {
    position.x -= gameRef.groundSpeed * dt;


    if (!_passed && !isTopPipe && position.x + size.x < gameRef.bird.position.x) {
      _passed = true;
      gameRef.incrementScore();
    }


    if (position.x + size.x < 0) {
      removeFromParent();
    }
  }

  bool get passed => _passed;  // Getter dla passed
  set passed(bool value) => _passed = value;  // Setter dla passed
}