import 'package:flutter/material.dart';
import 'dart:io';

class StartMenu extends StatelessWidget {
  final VoidCallback onPlay;

  const StartMenu({required this.onPlay, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF264653),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flappy Bird',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF9FBF2),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: onPlay,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE9C46A),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Play',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF264653),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                exit(0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Exit',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFFF9FBF2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}