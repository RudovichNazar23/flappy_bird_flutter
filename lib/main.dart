import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'game_logic.dart';
import 'components/startmenu.dart';
import 'components/difficulty_selection.dart';
import 'components/nickname_input.dart';
import 'splash_screen.dart';

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
  double _groundSpeed = 100;
  double _pipeSpawnDistance = 250;
  String _playerName = "";
  int _currentScreen = -1;

  void _startGame() {
    setState(() {
      _isPlaying = true;
    });
  }

  void _setDifficulty(double speed, double pipeSpawnDistance) {
    setState(() {
      _groundSpeed = speed;
      _pipeSpawnDistance = pipeSpawnDistance;
      _currentScreen = 2;
    });
  }

  void _setPlayerName(String name) {
    setState(() {
      _playerName = name;
      _startGame();
    });
  }

  void _navigateToDifficultySelection() {
    setState(() {
      _currentScreen = 1;
    });
  }

  void _navigateToStartMenu() {
    setState(() {
      _currentScreen = 0;
    });
  }

  void _navigateToNicknameInput() {
    setState(() {
      _currentScreen = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;


    switch (_currentScreen) {
      case 1:
        screen = DifficultySelection(
          onSetDifficulty: _setDifficulty,
          onBack: _navigateToStartMenu,
        );
        break;
      case 2:
        screen = NicknameInput(
          onSetPlayerName: _setPlayerName,
          onBack: _navigateToDifficultySelection,
        );
        break;
      default:
        screen = StartMenu(onPlay: _navigateToDifficultySelection);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _currentScreen == -1
          ? Scaffold(
        body: SplashScreen(
          onFinish: () {
            setState(() {
              _currentScreen = 0;
            });
          },
        ),
      )
          : _isPlaying
          ? GameWidget(
        game: FlutterBird(
          playerName: _playerName,
          groundSpeed: _groundSpeed,
          pipeSpawnDistance: _pipeSpawnDistance,
        ),
      )
          : screen,
    );
  }
}
