import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbird/splash_screen.dart';
import 'game_logic.dart';
import 'components/startmenu.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _isPlaying = false;
  bool _showSplash = true;
  double _groundSpeed = 100;
  String _playerName = ""; // Added a field to hold the player's nickname.

  void _startGame(double groundSpeed, String playerName) {
    setState(() {
      _isPlaying = true;
      _groundSpeed = groundSpeed;
      _playerName = playerName; // Store the player's nickname.
    });
  }

  void _finishSplash() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _showSplash
          ? SplashScreen(onFinish: _finishSplash)
          : (_isPlaying
          ? GameWidget(
        game: FlutterBird(
          playerName: _playerName, // Pass the player's nickname to the game.
          groundSpeed: _groundSpeed,
        ),
      )
          : StartMenu(onPlay: _startGame)), // Pass the updated _startGame method.
    );
  }
}
