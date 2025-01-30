import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pixel_button.dart';
import 'background_scaffold.dart';

class DifficultySelection extends StatelessWidget {
  final void Function(double, double) onSetDifficulty;

  const DifficultySelection({required this.onSetDifficulty, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDifficultyButton("Easy", 150, 250),
          const SizedBox(height: 20),
          _buildDifficultyButton("Medium", 400, 390),
          const SizedBox(height: 20),
          _buildDifficultyButton("Hard", 700, 600),
        ],
      ),
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