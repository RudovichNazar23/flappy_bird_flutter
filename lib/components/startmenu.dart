import 'package:flutter/material.dart';

class StartMenu extends StatefulWidget {
  final void Function(double, String) onPlay;

  const StartMenu({required this.onPlay, Key? key}) : super(key: key);

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> {
  final TextEditingController _nicknameController = TextEditingController();

  // Stałe wymiary dla przycisków
  static const double buttonWidth = 200.0;
  static const double buttonHeight = 60.0;
  static const double buttonFontSize = 32.0;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final minRequiredHeight = 600.0;
    final useHorizontalLayout = screenSize.height < minRequiredHeight;

    return Scaffold(
      backgroundColor: const Color(0xFF264653),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mountains.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenSize.height,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40.0,
                    horizontal: 20.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGameTitle(),
                      const SizedBox(height: 30),
                      _buildNicknameInput(),
                      const SizedBox(height: 30),
                      useHorizontalLayout
                          ? _buildHorizontalButtons()
                          : _buildVerticalButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameTitle() {
    return PixelContainer(
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Flappy Bird',
          style: TextStyle(
            fontSize: 54,
            fontFamily: 'PixelFont',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNicknameInput() {
    return PixelContainer(
      child: SizedBox(
        width: 300,
        child: TextField(
          controller: _nicknameController,
          decoration: InputDecoration(
            hintText: 'Enter your nickname',
            hintStyle: const TextStyle(
              fontFamily: 'PixelFont',
              color: Colors.grey,
              fontSize: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 3),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'PixelFont',
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildHorizontalButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDifficultyButton("Easy", 100),
        const SizedBox(width: 20),
        _buildDifficultyButton("Medium", 400),
        const SizedBox(width: 20),
        _buildDifficultyButton("Hard", 700),
      ],
    );
  }

  Widget _buildVerticalButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDifficultyButton("Easy", 100),
        const SizedBox(height: 20),
        _buildDifficultyButton("Medium", 400),
        const SizedBox(height: 20),
        _buildDifficultyButton("Hard", 700),
      ],
    );
  }

  Widget _buildDifficultyButton(String text, double speed) {
    return PixelButton(
      text: text,
      onPressed: () {
        final nickname = _nicknameController.text.trim();
        if (nickname.isNotEmpty) {
          widget.onPlay(speed, nickname);
        }
      },
      width: buttonWidth,
      height: buttonHeight,
      fontSize: buttonFontSize,
    );
  }
}

class PixelContainer extends StatelessWidget {
  final Widget child;

  const PixelContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent[200],
        border: Border.all(
          color: Colors.black,
          width: 5.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

class PixelButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double fontSize;

  const PixelButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.fontSize,
  }) : super(key: key);

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _isPressed
                ? Colors.purple[900]
                : _isHovered
                ? Colors.purple[700]
                : Colors.purple,
            border: Border.all(
              color: Colors.black,
              width: 5.0,
            ),
            boxShadow: _isPressed
                ? []
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                offset: const Offset(6, 6),
                blurRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontFamily: 'PixelFont',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}