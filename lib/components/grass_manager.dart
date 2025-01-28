import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutterbird/constants.dart';
import 'package:flutterbird/game_logic.dart';
import 'rock.dart';

class GrassManager extends Component with HasGameRef<FlutterBird> {
  double grassSpawnTimer = 0;

  @override
  void update(double dt) {
    grassSpawnTimer += dt;
    if (grassSpawnTimer > PipeInterval) {
      grassSpawnTimer = 0;
      spawnGrass();
    }
  }

  void spawnGrass() {
    final double screenHeight = gameRef.size.y;
    final double bottomGrassHeight = minRockHeight + Random().nextDouble() * (maxGrassHeight - minGrassHeight);

    final bottomRock = Rock(
      Vector2(gameRef.size.x + Random().nextInt(100) + 250, screenHeight - groundHeight - bottomGrassHeight),
      Vector2(pipeWidth, bottomGrassHeight),
    );

    gameRef.add(bottomRock);
  }
}