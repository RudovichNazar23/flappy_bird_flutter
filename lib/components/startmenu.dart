import 'package:flutter/material.dart';

class StartMenu extends StatelessWidget {
  final void Function(double) onPlay;

  const StartMenu({required this.onPlay, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.05;
    double buttonWidth = screenWidth * 0.3; // Adjusted for horizontal layout

    return Scaffold(
      backgroundColor: const Color(0xFF264653),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PixelContainer(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Flappy Bird',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize * 1.08,
                      fontFamily: 'PixelFont',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Wrap(
                spacing: 20.0, // Space between buttons
                runSpacing: 20.0, // Space between rows
                alignment: WrapAlignment.center,
                children: [
                  PixelButton(
                    text: "Easy",
                    onPressed: () => onPlay(100), // Pass speed for Easy mode
                    fontSize: fontSize,
                    buttonWidth: buttonWidth,
                  ),
                  PixelButton(
                    text: "Medium",
                    onPressed: () => onPlay(400), // Pass speed for Medium mode
                    fontSize: fontSize,
                    buttonWidth: buttonWidth,
                  ),
                  PixelButton(
                    text: "Hard",
                    onPressed: () => onPlay(700), // Pass speed for Hard mode
                    fontSize: fontSize,
                    buttonWidth: buttonWidth,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
        color: Colors.green,
        border: Border.all(
          color: Colors.black,
          width: 5.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(6, 6),
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
  final double fontSize;
  final double buttonWidth;

  const PixelButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.fontSize,
    required this.buttonWidth,
  }) : super(key: key);

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _isHovered ? Colors.green : Colors.yellow,
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
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontFamily: 'PixelFont',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}