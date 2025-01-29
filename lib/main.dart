import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbird/splash_screen.dart';
import 'game_logic.dart';
import 'components/startmenu.dart';
import 'constants.dart' show groundSpeed;


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
  String _playerName = "";
  double _pipeSpawnDistance = 250;

  void _startGame(double groundSpeed, double pipeSpawnDistance , String playerName) {
    setState(() {
      _isPlaying = true;
      _groundSpeed = groundSpeed;
      _playerName = playerName;
      _pipeSpawnDistance = pipeSpawnDistance;
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
          playerName: _playerName,
          groundSpeed: _groundSpeed,
          pipeSpawnDistance: _pipeSpawnDistance,
        ),
      )
          : StartMenu(onPlay: _startGame)),
    );
  }
}