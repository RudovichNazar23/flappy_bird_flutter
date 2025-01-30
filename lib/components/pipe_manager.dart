import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutterbird/constants.dart';
import 'package:flutterbird/game_logic.dart';
import 'pipe.dart';

class PipeManager extends Component with HasGameRef<FlutterBird> {
  double pipeSpawnTimer = 0;
  Vector2 _lastSize = Vector2.zero();
  final List<Pipe> activePipes = [];

  @override
  void update(double dt) {
    super.update(dt);

    // Sprawdź zmianę rozmiaru tylko jeśli faktycznie się zmieniła
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
    activePipes.removeWhere((pipe) {
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

    // Usuń wszystkie rury i zresetuj timer przy zmianie rozmiaru
    for (var pipe in activePipes) {
      pipe.removeFromParent();
    }
    activePipes.clear();
    pipeSpawnTimer = 0;
  }

  void spawnPipe() {
    final double screenHeight = gameRef.size.y;
    final double maxPipeHeight = screenHeight - groundHeight - PipeGap - minPipeHeight;
    final double bottomPipeHeight = minPipeHeight + Random().nextDouble() * (maxPipeHeight - minPipeHeight);
    final double topPipeHeight = screenHeight - groundHeight - bottomPipeHeight - PipeGap;

    // Sprawdź czy jest wystarczająco miejsca
    if (screenHeight - groundHeight - PipeGap <= 2 * minPipeHeight) return;

    // Dodatkowe sprawdzenie bezpieczeństwa
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

    // Dodaj do listy aktywnych rur
    activePipes.add(topPipe);
    activePipes.add(bottomPipe);

    // Dodaj do gry
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
    activePipes.clear();
    super.onRemove();
  }
}