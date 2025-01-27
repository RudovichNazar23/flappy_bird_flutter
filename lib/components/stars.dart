import 'dart:async';

import 'package:flame/components.dart';


class Stars extends SpriteComponent {
  Stars(Vector2 size)
      : super(
    size: size,
    position: Vector2(0, 0),
  );
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('green-stars.png');
  }
}
