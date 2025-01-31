import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flame/game.dart';
import 'pixel_button.dart';
import 'pixel_container.dart';
import 'menu_background.dart';

class MenuGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(MenuBackground(
      canvasSize,
      mountainsHeightRatio: 0.3,
      starsHeightRatio: 0.5,
    ));
  }
}

class DifficultySelection extends StatelessWidget {
  final void Function(double, double) onSetDifficulty;
  final VoidCallback onBack;

  const DifficultySelection({required this.onSetDifficulty, required this.onBack, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: GameWidget(
            game: MenuGame(),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildDifficultyButton("Easy", 150, 250),
                const SizedBox(height: 20),
                _buildDifficultyButton("Medium", 400, 390),
                const SizedBox(height: 20),
                _buildDifficultyButton("Hard", 700, 600),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Centrowany container z tekstem
            Center(
              child: PixelContainer(
                backgroundColor: const Color(0xFF123d8c),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    'Wybierz poziom',
                    style: GoogleFonts.inter(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // Strzałka powrotu obok buttona
            Positioned(
              left: constraints.maxWidth / 2 - 230, // Dostosuj tę wartość by zmienić odległość
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1be2bc)),
                onPressed: onBack,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDifficultyButton(String text, double speed, double pipeSpawnDistance) {
    return PixelButton(
      text: text,
      onPressed: () {
        onSetDifficulty(speed, pipeSpawnDistance);
      },
      width: 300,
      height: 70,
      fontSize: 40,
    );
  }
}