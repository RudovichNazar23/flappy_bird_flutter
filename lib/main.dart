import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbird/splash_screen.dart';
import 'game_logic.dart';
import 'components/startmenu.dart';


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
  String _playerName = '';

  void _startGame() {
    setState(() {
      _isPlaying = true;
    });
  }

  void _setPlayerName(String name) {
    setState(() {
      _playerName = name;
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
          ? GameWidget(game: FlutterBird(playerName: _playerName))
          : StartMenu(onPlay: _startGame, onSetPlayerName: _setPlayerName)),
    );
  }
}