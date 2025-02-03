import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class Background extends Component {
  late SpriteComponent mountains;
  late SpriteComponent stars;
  Vector2 size;
  static const double MOUNTAINS_HEIGHT_RATIO = 0.4;
  static const double STARS_HEIGHT_RATIO = 0.4;

  Background(this.size) {
    mountains = SpriteComponent();
    stars = SpriteComponent();
  }

  @override
  Future<void> onLoad() async {
    print('Starting to load background assets...');


    final backgroundComponent = RectangleComponent(
      position: Vector2.zero(),
      size: size,
      paint: Paint()..color = const Color(0xFF1560bd),
    );
    add(backgroundComponent);

    try {
      print('Attempting to load mountains.png...');
      mountains
        ..sprite = await Sprite.load('mountains.png')
        ..position = Vector2(0, size.y * (1 - MOUNTAINS_HEIGHT_RATIO) - groundHeight)
        ..size = Vector2(size.x, size.y * MOUNTAINS_HEIGHT_RATIO);
      print('Successfully loaded mountains.png');
      add(mountains);
    } catch (e) {
      print('Error loading mountains.png: $e');
    }

    try {
      print('Attempting to load green_stars.png...');
      stars
        ..sprite = await Sprite.load('green-stars.png')
        ..position = Vector2.zero()
        ..size = Vector2(size.x, size.y * STARS_HEIGHT_RATIO);
      print('Successfully loaded green_stars.png');
      add(stars);
    } catch (e) {
      print('Error loading green_stars.png: $e');
    }
  }

  @override
  void onGameResize(Vector2 newSize) {
    size = newSize;


    final backgroundRect = children.whereType<RectangleComponent>().firstOrNull;
    if (backgroundRect != null) {
      backgroundRect.size = newSize;
    }


    if (mountains.sprite != null) {
      mountains
        ..size = Vector2(newSize.x, newSize.y * MOUNTAINS_HEIGHT_RATIO)
        ..position = Vector2(0, newSize.y * (1 - MOUNTAINS_HEIGHT_RATIO) - groundHeight);
    }

    if (stars.sprite != null) {
      stars
        ..size = Vector2(newSize.x, newSize.y * STARS_HEIGHT_RATIO)
        ..position = Vector2.zero();
    }

    super.onGameResize(newSize);
  }
}