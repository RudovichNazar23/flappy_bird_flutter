// item.dart
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutterbird/game_logic.dart';
import 'dart:async';
import '../constants.dart';

class Item extends SpriteComponent with CollisionCallbacks, HasGameRef<FlutterBird> {
  final String imageName;
  Vector2 _lastSize = Vector2.zero();
  final double _distanceFromGround; // Zapisujemy odległość od ziemi zamiast ratio

  Item(Vector2 position, Vector2 size, this.imageName, {int priority = 1})
      : _distanceFromGround = position.y - (position.y + size.y),
        super(position: position, size: size, priority: 1);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(imageName);
    add(RectangleHitbox());
    _lastSize = gameRef.size.clone();
  }

  @override
  void update(double dt) {
    position.x -= gameRef.groundSpeed * dt;
    if (position.x + size.x <= 0) {
      removeFromParent();
    }

    if (_lastSize.x != gameRef.size.x || _lastSize.y != gameRef.size.y) {
      handleResize(gameRef.size);
      _lastSize = gameRef.size.clone();
    }
  }

  @override
  void handleResize(Vector2 newSize) {
    super.handleResize(newSize);
    // Zachowujemy stałą odległość od ziemi
    position.y = newSize.y - groundHeight + _distanceFromGround;
  }
}