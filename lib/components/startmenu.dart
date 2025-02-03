import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flame/game.dart';
import 'dart:io';
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

class StartMenu extends StatelessWidget {
  final VoidCallback onPlay;

  const StartMenu({required this.onPlay, Key? key}) : super(key: key);

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
                _buildGameTitle(),
                const SizedBox(height: 30),
                _buildPlayButton(),
                const SizedBox(height: 20),
                _buildExitButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameTitle() {
    return PixelContainer(
      backgroundColor: const Color(0xFF123d8c),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'Galactic Glide',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 45,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return PixelButton(
      text: "Play",
      onPressed: onPlay,
      width: 300,
      height: 70,
      fontSize: 40,
    );
  }

  Widget _buildExitButton() {
    return PixelButton(
      text: "Exit",
      onPressed: () => exit(0),
      width: 300,
      height: 70,
      fontSize: 40,
    );
  }
}