import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartMenu extends StatefulWidget {
  final void Function(double, double, String) onPlay;

  const StartMenu({required this.onPlay, Key? key}) : super(key: key);

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> {
  final TextEditingController _nicknameController = TextEditingController();

  static const double buttonWidth = 300.0;
  static const double buttonHeight = 70.0;
  static const double buttonFontSize = 40.0;

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
      backgroundColor: const Color(0xFF123d8c),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'Flappy Bird',
          style: GoogleFonts.inter(
            fontSize: 60,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildNicknameInput() {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: _nicknameController,
        decoration: InputDecoration(
          hintText: 'Enter your nickname',
          hintStyle: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFB8FFF1),
        ),
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildHorizontalButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDifficultyButton("Easy", 150, 250),
        const SizedBox(width: 20),
        _buildDifficultyButton("Medium", 400, 390),
        const SizedBox(width: 20),
        _buildDifficultyButton("Hard", 700, 600),
      ],
    );
  }

  Widget _buildVerticalButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDifficultyButton("Easy", 150, 250),
        const SizedBox(height: 20),
        _buildDifficultyButton("Medium", 400, 390),
        const SizedBox(height: 20),
        _buildDifficultyButton("Hard", 700, 600),
      ],
    );
  }

  Widget _buildDifficultyButton(String text, double speed, double pipeSpawnDistance) {
    return PixelButton(
      text: text,
      onPressed: () {
        final nickname = _nicknameController.text.trim();
        if (nickname.isNotEmpty) {
          widget.onPlay(speed, pipeSpawnDistance, nickname);
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
  final Color backgroundColor;

  const PixelContainer({Key? key, required this.child, this.backgroundColor = Colors.blueAccent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}

class PixelButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF1be2bc),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: fontSize,
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
