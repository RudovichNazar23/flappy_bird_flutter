import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'game_logic.dart';
import 'constants.dart';
import 'components/startmenu.dart';
import 'components/difficulty_selection.dart';
import 'components/nickname_input.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class TimerWidget extends StatefulWidget {
  final Function(int) onTimeUpdate;
  final VoidCallback? onTimerEnd;
  final ValueNotifier<bool> resetTrigger;
  final ValueNotifier<bool> stopTrigger;

  const TimerWidget({
    super.key,
    required this.onTimeUpdate,
    this.onTimerEnd,
    required this.resetTrigger,
    required this.stopTrigger,
  });

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  final ValueNotifier<int> _timeLeft = ValueNotifier<int>(60);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();

    widget.resetTrigger.addListener(() {
      if (widget.resetTrigger.value) {
        startTimer();
        widget.resetTrigger.value = false;
      }
    });

    widget.stopTrigger.addListener(() {
      if (widget.stopTrigger.value) {
        _timer?.cancel();
      }
    });
  }

  void startTimer() {
    _timeLeft.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.value > 0) {
        _timeLeft.value--;
        widget.onTimeUpdate(_timeLeft.value);
      } else {
        _timer?.cancel();
        widget.onTimerEnd?.call();
      }
    });
  }

  String _formatTime(int timeInSeconds) {
    int minutes = timeInSeconds ~/ 60;
    int seconds = timeInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timeLeft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _timeLeft,
      builder: (context, timeLeft, child) {
        return Text(
          _formatTime(timeLeft),
          style: GoogleFonts.inter(
            fontSize: 42,
            color: const Color(0xFF1aae94),
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }
}

class MyAppState extends State<MyApp> {
  bool _isPlaying = false;
  double _groundSpeed = 100;
  double _pipeSpawnDistance = 250;
  String _playerName = "";
  int _currentScreen = 0;
  FlutterBird? _game;
  final ValueNotifier<bool> _resetTrigger = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _stopTrigger = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _resetTrigger.dispose();
    _stopTrigger.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _stopTrigger.value = false;
      _game = FlutterBird(
        playerName: _playerName,
        groundSpeed: _groundSpeed,
        pipeSpawnDistance: _pipeSpawnDistance,
        onRestart: _handleGameRestart,
        onGameOver: _handleGameOver,
      );
    });
  }

  void _handleGameRestart() {
    _resetTrigger.value = true;
    _stopTrigger.value = false;
  }

  void _handleGameOver() {
    _stopTrigger.value = true;
  }

  void _updateGameTime(int timeLeft) {
    _game?.updateRemainingTime(timeLeft.toDouble());
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
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: _isPlaying
          ? Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0d1b39),
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 100,
          leadingWidth: 180,
          leading: Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              top: 16.0,
              bottom: 16.0,
            ),
            child: SizedBox(
              width: 120,
              child: Image.asset(
                'assets/images/KaliopLogo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          flexibleSpace: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 10),
            child: TimerWidget(
              onTimeUpdate: _updateGameTime,
              resetTrigger: _resetTrigger,
              stopTrigger: _stopTrigger,
            ),
          ),
          title: const SizedBox(),
        ),
        body: Container(
          color: const Color(0xFF0d1b39),
          child: GameWidget<FlutterBird>(
            game: _game!,
            overlayBuilderMap: {},
          ),
        ),
      )
          : screen,
    );
  }
}