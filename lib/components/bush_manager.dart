import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutterbird/constants.dart';
import 'package:flutterbird/game_logic.dart';
import 'bush.dart' show Bush;

class BushManager extends Component with HasGameRef<FlutterBird> {
  double bushSpawnTimer = 0;

  @override
  void update(double dt) {
    bushSpawnTimer += dt;
    if (bushSpawnTimer > PipeInterval) {
      bushSpawnTimer = 0;
      spawnBush();
    }
  }

  void spawnBush() {
    final double screenHeight = gameRef.size.y;
    final double bottomBushHeight = minBushHeight + Random().nextDouble() * (maxBushHeight - minBushHeight);

    final bush = Bush(
      Vector2(gameRef.size.x + Random().nextInt(150) + 400, screenHeight - groundHeight - bottomBushHeight),
      Vector2(pipeWidth, bottomBushHeight),
    );

    gameRef.add(bush);
  }
}