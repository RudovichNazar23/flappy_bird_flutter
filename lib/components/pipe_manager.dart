import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutterbird/constants.dart';
import 'package:flutterbird/game_logic.dart';
import 'pipe.dart';

class PipeManager extends Component with HasGameRef<FlutterBird> {
  double pipeSpawnTimer = 0;

  @override
  void update(double dt) {
    pipeSpawnTimer += dt;
    if (pipeSpawnTimer > PipeInterval) {
      pipeSpawnTimer = 0;
      spawnPipe();
    }
  }

  void spawnPipe() {
    final double screenHeight = gameRef.size.y;
    final double maxPipeHeight = screenHeight - groundHeight - PipeGap - minPipeHeight;
    final double bottomPipeHeight = minPipeHeight + Random().nextDouble() * (maxPipeHeight - minPipeHeight);
    final double topPipeHeight = screenHeight - groundHeight - bottomPipeHeight - PipeGap;

    final bottomPipe = Pipe(
      Vector2(gameRef.size.x, screenHeight - groundHeight - bottomPipeHeight),
      Vector2(pipeWidth, bottomPipeHeight),
      isTopPipe: false,
    );

    final topPipe = Pipe(
      Vector2(gameRef.size.x, 0),
      Vector2(pipeWidth, topPipeHeight),
      isTopPipe: true,
    );

    gameRef.add(bottomPipe);
    gameRef.add(topPipe);
  }
}