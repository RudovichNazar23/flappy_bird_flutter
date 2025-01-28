import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutterbird/constants.dart';
import 'package:flutterbird/game_logic.dart';
import 'item.dart' show Item;

class ItemManager extends Component with HasGameRef<FlutterBird> {
  final String imageName;
  double itemSpawnTimer = 0;

  ItemManager(this.imageName);

  @override
  void update(double dt) {
    itemSpawnTimer += dt;
    if (itemSpawnTimer > itemInterval) {
      itemSpawnTimer = 0;
      spawnItem();
    }
  }

  void spawnItem() {
    final double screenHeight = gameRef.size.y;
    final double bottomItemHeight = minItemHeight + Random().nextDouble() * (maxItemHeight - minItemHeight);

    final item = Item(
      Vector2(
          gameRef.size.x + Random().nextInt(Random().nextInt(100) + 50) +
              Random().nextInt(100) + 50,
          screenHeight - groundHeight - bottomItemHeight
      ),
      Vector2(pipeWidth, bottomItemHeight),
      imageName,
    );

    gameRef.add(item);
  }
}