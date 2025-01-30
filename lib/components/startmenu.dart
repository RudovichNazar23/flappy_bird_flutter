import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'pixel_button.dart';
import 'background_scaffold.dart';
import 'pixel_container.dart'; // Zaktualizowany import

class StartMenu extends StatelessWidget {
  final VoidCallback onPlay;

  const StartMenu({required this.onPlay, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
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
    );
  }

  Widget _buildGameTitle() {
    return PixelContainer(
      backgroundColor: const Color(0xFF123d8c),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'Flappy Bird',
          style: GoogleFonts.inter(
            fontSize: 60,
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