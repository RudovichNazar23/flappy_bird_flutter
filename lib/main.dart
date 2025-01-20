import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game_logic.dart';
import 'components/startmenu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _isPlaying = false;

  void _startGame() {
    setState(() {
      _isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _isPlaying ? GameWidget(game: FlutterBird()) : StartMenu(onPlay: _startGame),
    );
  }
}
