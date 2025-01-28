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
    if (pipeSpawnTimer > PipeInterval) {
      pipeSpawnTimer = 0;
      spawnPipe();
    }

    // Czyść nieaktywne rury
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

    // Przetwarzaj tylko aktywne rury
    for (int i = 0; i < activePipes.length; i += 2) {
      if (i + 1 >= activePipes.length) break;

      final Pipe topPipe = activePipes[i].isTopPipe ? activePipes[i] : activePipes[i + 1];
      final Pipe bottomPipe = activePipes[i].isTopPipe ? activePipes[i + 1] : activePipes[i];

      final double originalX = topPipe.position.x;
      final double totalHeight = availableHeight;

      // Zachowaj proporcje wysokości
      final double ratio = bottomPipe.size.y / (totalHeight - topPipe.size.y);
      final double newBottomHeight = max(minPipeHeight, (totalHeight * ratio) / (1 + ratio));
      final double newTopHeight = max(minPipeHeight, totalHeight - newBottomHeight);

      // Aktualizuj tylko jeśli wysokości się mieszczą w limitach
      if (newBottomHeight >= minPipeHeight && newTopHeight >= minPipeHeight) {
        topPipe.size.y = newTopHeight;
        bottomPipe.size.y = newBottomHeight;

        topPipe.position.x = originalX;
        bottomPipe.position.x = originalX;
        topPipe.position.y = 0;
        bottomPipe.position.y = screenHeight - groundHeight - newBottomHeight;
      }
    }
  }

  void spawnPipe() {
    final double screenHeight = gameRef.size.y;
    final double availableHeight = screenHeight - groundHeight - PipeGap;

    // Sprawdź czy jest wystarczająco miejsca
    if (availableHeight <= 2 * minPipeHeight) return;

    // Oblicz wysokości rur
    final double maxPipeSpace = availableHeight - 2 * minPipeHeight;
    final double randomValue = Random().nextDouble();

    final double bottomPipeHeight = minPipeHeight + (randomValue * maxPipeSpace);
    final double topPipeHeight = availableHeight - bottomPipeHeight;

    // Dodatkowe sprawdzenie bezpieczeństwa
    if (bottomPipeHeight < minPipeHeight || topPipeHeight < minPipeHeight) return;

    final double spawnX = isFirstSpawn ? gameRef.size.x : gameRef.size.x;

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