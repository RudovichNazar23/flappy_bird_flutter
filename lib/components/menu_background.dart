import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class MenuBackground extends Component {
  late SpriteComponent mountains;
  late SpriteComponent stars;
  late SpriteComponent topPipe;
  late SpriteComponent bottomPipe;
  Vector2 size;
  final double mountainsHeightRatio;
  final double starsHeightRatio;
  final double pipeWidth = 100.0; // Szerokość rury
  final double gapHeight = 200.0; // Wysokość przerwy między rurami

  MenuBackground(
      this.size, {
        this.mountainsHeightRatio = 0.4,
        this.starsHeightRatio = 0.4,
      }) {
    mountains = SpriteComponent();
    stars = SpriteComponent();
    topPipe = SpriteComponent();
    bottomPipe = SpriteComponent();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final backgroundComponent = RectangleComponent(
      position: Vector2.zero(),
      size: size,
      paint: Paint()..color = const Color(0xFF1560bd),
    );
    add(backgroundComponent);

    try {
      mountains.sprite = await Sprite.load('mountains.png');
      mountains.position = Vector2(0, size.y * (1 - mountainsHeightRatio));
      mountains.size = Vector2(size.x, size.y * mountainsHeightRatio);
      add(mountains);
    } catch (e) {
      print('Error loading mountains.png: $e');
    }

    try {
      stars.sprite = await Sprite.load('green-stars.png');
      stars.position = Vector2.zero();
      stars.size = Vector2(size.x, size.y * starsHeightRatio);
      add(stars);
    } catch (e) {
      print('Error loading green_stars.png: $e');
    }

    // Dodawanie rur
    try {
      // Górna rura
      topPipe.sprite = await Sprite.load('pipe-top.png');
      double centerX = size.x / 2 - pipeWidth / 2;
      topPipe.position = Vector2(centerX, 0);
      topPipe.size = Vector2(pipeWidth, size.y / 2 - gapHeight / 2);
      add(topPipe);

      // Dolna rura
      bottomPipe.sprite = await Sprite.load('pipe-bottom.png');
      bottomPipe.position = Vector2(centerX, size.y / 2 + gapHeight / 2);
      bottomPipe.size = Vector2(pipeWidth, size.y / 2 - gapHeight / 2);
      add(bottomPipe);
    } catch (e) {
      print('Error loading pipes: $e');
    }
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    size = newSize;

    final backgroundRect = children.whereType<RectangleComponent>().firstOrNull;
    if (backgroundRect != null) {
      backgroundRect.size = newSize;
    }

    if (mountains.sprite != null) {
      mountains.size = Vector2(newSize.x, newSize.y * mountainsHeightRatio);
      mountains.position = Vector2(0, newSize.y * (1 - mountainsHeightRatio));
    }

    if (stars.sprite != null) {
      stars.size = Vector2(newSize.x, newSize.y * starsHeightRatio);
      stars.position = Vector2.zero();
    }

    // Aktualizacja pozycji i rozmiaru rur
    if (topPipe.sprite != null && bottomPipe.sprite != null) {
      double centerX = newSize.x / 2 - pipeWidth / 2;

      topPipe.position = Vector2(centerX, 0);
      topPipe.size = Vector2(pipeWidth, newSize.y / 2 - gapHeight / 2);

      bottomPipe.position = Vector2(centerX, newSize.y / 2 + gapHeight / 2);
      bottomPipe.size = Vector2(pipeWidth, newSize.y / 2 - gapHeight / 2);
    }
  }
}