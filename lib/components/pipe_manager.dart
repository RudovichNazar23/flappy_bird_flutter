import 'dart:math';
import 'package:flame/components.dart';
import 'package:galacticglide/constants.dart';
import 'package:galacticglide/game_logic.dart';
import 'pipe.dart';

class PipeManager extends Component with HasGameRef<FlutterBird> {
  double pipeSpawnTimer = 0;
  Vector2 _lastSize = Vector2.zero();
  final List<Pipe> _activePipes = [];

  List<Pipe> get pipes => _activePipes;

  @override
  void update(double dt) {
    super.update(dt);


    if (_lastSize.x != gameRef.size.x || _lastSize.y != gameRef.size.y) {
      _handleResizeChange();
      _lastSize = gameRef.size.clone();
    }

    pipeSpawnTimer += dt;
    if (pipeSpawnTimer > gameRef.pipeSpawnDistance / gameRef.groundSpeed) {
      pipeSpawnTimer = 0;
      spawnPipe();
    }

    _cleanupInactivePipes();
  }

  void _cleanupInactivePipes() {
    _activePipes.removeWhere((pipe) {
      if (pipe.position.x + pipe.size.x < 0) {
        pipe.removeFromParent();
        return true;
      }
      return false;
    });
  }

  void _handleResizeChange() {
    final double screenHeight = gameRef.size.y;
    final double availableHeight = screenHeight - groundHeight - PipeGap;


    for (var pipe in _activePipes) {
      pipe.removeFromParent();
    }
    _activePipes.clear();
    pipeSpawnTimer = 0;
  }

  void spawnPipe() {
    final double screenHeight = gameRef.size.y;
    final double maxPipeHeight = screenHeight - groundHeight - PipeGap - minPipeHeight;
    final double bottomPipeHeight = minPipeHeight + Random().nextDouble() * (maxPipeHeight - minPipeHeight);
    final double topPipeHeight = screenHeight - groundHeight - bottomPipeHeight - PipeGap;


    if (screenHeight - groundHeight - PipeGap <= 2 * minPipeHeight) return;


    if (bottomPipeHeight < minPipeHeight || topPipeHeight < minPipeHeight) return;

    final double spawnX = gameRef.size.x + pipeWidth;

    final bottomPipe = Pipe(
      Vector2(spawnX, screenHeight - groundHeight - bottomPipeHeight),
      Vector2(pipeWidth, bottomPipeHeight),
      isTopPipe: false,
    );

    final topPipe = Pipe(
      Vector2(spawnX, 0),
      Vector2(pipeWidth, topPipeHeight),
      isTopPipe: true,
    );


    _activePipes.add(topPipe);
    _activePipes.add(bottomPipe);


    gameRef.add(bottomPipe);
    gameRef.add(topPipe);
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    _handleResizeChange();
  }

  @override
  void onRemove() {
    _activePipes.clear();
    super.onRemove();
  }

  void reset() {
    _activePipes.clear();
  }
}