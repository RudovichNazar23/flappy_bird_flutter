import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game_logic.dart';

class ResponsiveWidget extends StatefulWidget {
  final FlutterBird gameInstance;
  final ValueNotifier<Size> resolutionNotifier;

  const ResponsiveWidget({
    Key? key,
    required this.gameInstance,
    required this.resolutionNotifier,
  }) : super(key: key);

  @override
  _ResponsiveWidgetState createState() => _ResponsiveWidgetState();
}

class _ResponsiveWidgetState extends State<ResponsiveWidget> {
  @override
  void initState() {
    super.initState();
    widget.resolutionNotifier.addListener(_onResolutionChanged);
  }

  @override
  void dispose() {
    widget.resolutionNotifier.removeListener(_onResolutionChanged);
    super.dispose();
  }

  void _onResolutionChanged() {
    final newSize = Vector2(widget.resolutionNotifier.value.width, widget.resolutionNotifier.value.height);
    widget.gameInstance.background.size = newSize;
    widget.gameInstance.ground.size = newSize;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return DesktopWidget(gameInstance: widget.gameInstance);
        } else {
          return MobileWidget(gameInstance: widget.gameInstance);
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