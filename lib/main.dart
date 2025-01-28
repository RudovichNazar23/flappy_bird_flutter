import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbird/responsive_layout_helper.dart';
import 'package:flutterbird/responsive_widget.dart';
import 'package:flutterbird/responsivewidget.dart';
import 'package:flutterbird/splash_screen.dart';
import 'game_logic.dart';
import 'components/startmenu.dart';
import 'constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  });
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
  final ValueNotifier<Size> _resolutionNotifier = ValueNotifier<Size>(const Size(800, 600));
  FlutterBird? _gameInstance;

  void _startGame(double groundSpeed, double pipeSpawnDistance , String playerName) {
    setState(() {
      _isPlaying = true;
      _groundSpeed = groundSpeed;
      _playerName = playerName;
      _gameInstance = FlutterBird(
          groundSpeed: groundSpeed,
          playerName: playerName,
          resolutionNotifier: _resolutionNotifier
      );
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
      theme: ThemeData(
        fontFamily: 'PixelFont',
      ),
      home: _showSplash
          ? SplashScreen(onFinish: _finishSplash)
          : (_isPlaying
          ? ResponsiveWidget(
        gameInstance: _gameInstance!,
        resolutionNotifier: _resolutionNotifier,
      )
          : StartMenu(onPlay: _startGame)),
    );
  }
}