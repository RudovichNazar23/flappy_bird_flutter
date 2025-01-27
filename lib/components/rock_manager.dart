import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutterbird/constants.dart';
import 'package:flutterbird/game_logic.dart';
import 'rock.dart';

class RockManager extends Component with HasGameRef<FlutterBird> {
  double rockSpawnTimer = 0;

  @override
  void update(double dt) {
    rockSpawnTimer += dt;
    if (rockSpawnTimer > PipeInterval) {
      rockSpawnTimer = 0;
      spawnRock();
    }
  }

  void spawnRock() {
    final double screenHeight = gameRef.size.y;
    // final double maxRockHeight = screenHeight - groundHeight - PipeGap - minRockHeight;
    final double bottomRockHeight = minRockHeight + Random().nextDouble() * (maxRockHeight - minRockHeight);

    final bottomRock = Rock(
      Vector2(gameRef.size.x + Random().nextInt(400) + 600, screenHeight - groundHeight - bottomRockHeight),
      Vector2(pipeWidth, bottomRockHeight),
    );

    gameRef.add(bottomRock);
  }
}