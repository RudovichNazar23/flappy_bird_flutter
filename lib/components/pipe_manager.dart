import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutterbird/constants.dart';
import 'package:flutterbird/game_logic.dart';
import 'pipe.dart';

class PipeManager extends Component with HasGameRef<FlutterBird> {
  double pipeSpawnTimer = 0;

  @override
  void update(double dt) {
    super.update(dt);
    pipeSpawnTimer += dt;

    if (pipeSpawnTimer > PipeInterval) {
      pipeSpawnTimer = 0;
      spawnPipe();
    }
  }

  void spawnPipe() {
    final double screenHeight = gameRef.size.y;
    final double maxPipeHeight = screenHeight - groundHeight - PipeGap - minPipeHeight;
    final double bottomPipeHeight =
        minPipeHeight + Random().nextDouble() * (maxPipeHeight - minPipeHeight);
    final double topPipeHeight = screenHeight - groundHeight - bottomPipeHeight - PipeGap;

    final bottomPipe = Pipe(
      Vector2(gameRef.size.x, screenHeight - groundHeight - bottomPipeHeight),
      Vector2(pipeWidth, bottomPipeHeight),
      isTopPipe: false,
    );

    final topPipe = Pipe(
      Vector2(gameRef.size.x, screenHeight - groundHeight - bottomPipeHeight - PipeGap - topPipeHeight),
      Vector2(pipeWidth, topPipeHeight),
      isTopPipe: true,
    );

    // Add pipes to the game
    gameRef.add(bottomPipe);
    gameRef.add(topPipe);
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    final double screenHeight = newSize.y;
    final double maxPipeHeight = screenHeight - groundHeight - PipeGap - minPipeHeight;

    gameRef.children.whereType<Pipe>().forEach((pipe) {
      if (pipe.isTopPipe) {
        final double bottomPipeHeight = screenHeight - groundHeight - pipe.size.y - PipeGap;
        pipe.position = Vector2(pipe.position.x, screenHeight - groundHeight - bottomPipeHeight - PipeGap - pipe.size.y);
      } else {
        pipe.position = Vector2(pipe.position.x, screenHeight - groundHeight - pipe.size.y);
      }
    });
  }
}
