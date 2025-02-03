// item_manager.dart
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutterbird/constants.dart';
import 'package:flutterbird/game_logic.dart';
import 'item.dart';

class ItemManager extends Component with HasGameRef<FlutterBird> {
  final String imageName;
  double itemSpawnTimer = 0;
  double lastSpawnX = 0;
  final Random _random = Random();
  Vector2 _lastSize = Vector2.zero();
  final List<Item> activeItems = [];

  final double minSpawnInterval = 3;
  final double maxSpawnInterval = 5;
  final double minSpawnDistance = 200;

  final double minItemHeight = 25.0;
  final double maxItemHeight = 75.0;
  final double aspectRatio = 0.8;

  ItemManager(this.imageName);

  @override
  void update(double dt) {
    if (_lastSize.x != gameRef.size.x || _lastSize.y != gameRef.size.y) {
      _handleResizeChange();
      _lastSize = gameRef.size.clone();
    }

    itemSpawnTimer += dt;
    if (itemSpawnTimer > _getRandomInterval() && canSpawnItem()) {
      itemSpawnTimer = 0;
      spawnItem();
    }

    _cleanupInactiveItems();
  }

  double _getRandomInterval() {
    return minSpawnInterval + _random.nextDouble() * (maxSpawnInterval - minSpawnInterval);
  }

  bool canSpawnItem() {
    if (activeItems.isEmpty) return true;

    double minX = double.infinity;
    for (var item in activeItems) {
      if (item.position.x < minX) {
        minX = item.position.x;
      }
    }

    return (gameRef.size.x - minX) >= minSpawnDistance;
  }

  void _cleanupInactiveItems() {
    activeItems.removeWhere((item) {
      if (item.position.x + item.size.x < 0) {
        item.removeFromParent();
        return true;
      }
      return false;
    });
  }

  void _handleResizeChange() {
    for (var item in activeItems) {
      item.handleResize(gameRef.size);
    }
  }

  void spawnItem() {
    final double screenHeight = gameRef.size.y;

    final double itemHeight = minItemHeight + _random.nextDouble() * (maxItemHeight - minItemHeight);
    final double itemWidth = itemHeight * aspectRatio;

    final double maxYOffset = 15.0;
    final double randomYOffset = _random.nextDouble() * maxYOffset;
    final double itemY = screenHeight - groundHeight - itemHeight - randomYOffset;

    final double baseX = gameRef.size.x;
    final double randomOffset = 30 + _random.nextDouble() * 70;

    final item = Item(
      Vector2(baseX + randomOffset, itemY),
      Vector2(itemWidth, itemHeight),
      imageName,
    );

    activeItems.add(item);
    gameRef.add(item);
    lastSpawnX = baseX + randomOffset;

    if (_random.nextDouble() < 0.2 &&
        baseX + randomOffset + minSpawnDistance < gameRef.size.x + 300) {

      final double additionalItemHeight = minItemHeight + _random.nextDouble() * (maxItemHeight - minItemHeight);
      final double additionalItemWidth = additionalItemHeight * aspectRatio;
      final double additionalOffset = randomOffset + minSpawnDistance;
      final double additionalYOffset = _random.nextDouble() * maxYOffset;
      final double additionalItemY = screenHeight - groundHeight - additionalItemHeight - additionalYOffset;

      final additionalItem = Item(
        Vector2(baseX + additionalOffset, additionalItemY),
        Vector2(additionalItemWidth, additionalItemHeight),
        imageName,
      );

      activeItems.add(additionalItem);
      gameRef.add(additionalItem);
      lastSpawnX = baseX + additionalOffset;
    }
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    _handleResizeChange();
  }

  @override
  void onRemove() {
    for (var item in activeItems) {
      item.removeFromParent();
    }
    activeItems.clear();
    super.onRemove();
  }
}