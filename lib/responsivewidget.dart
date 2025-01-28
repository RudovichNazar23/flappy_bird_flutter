import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game_logic.dart';

class ResponsiveWidget extends StatelessWidget {
  final FlutterBird gameInstance = FlutterBird(groundSpeed: 100);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // If the width is greater than 600, consider it a desktop
          return DesktopWidget(gameInstance: gameInstance);
        } else {
          // Otherwise, consider it a mobile device
          return MobileWidget(gameInstance: gameInstance);
        }
      },
    );
  }
}

class DesktopWidget extends StatelessWidget {
  final FlutterBird gameInstance;

  const DesktopWidget({required this.gameInstance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: gameInstance,
      ),
    );
  }
}

class MobileWidget extends StatelessWidget {
  final FlutterBird gameInstance;

  const MobileWidget({required this.gameInstance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: gameInstance,
      ),
    );
  }
}