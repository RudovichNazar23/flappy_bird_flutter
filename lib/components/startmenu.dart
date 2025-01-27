import 'package:flutter/material.dart';

class StartMenu extends StatefulWidget {
  final void Function(double, String) onPlay;

  const StartMenu({required this.onPlay, Key? key}) : super(key: key);

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> {
  final TextEditingController _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    style: const TextStyle(
                      fontSize: 54,
                      fontFamily: 'PixelFont',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              // Pole tekstowe dla nicka
              PixelContainer(
                child: SizedBox(
                  width: 300, // Szerokość boxa
                  child: TextField(
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your nickname',
                      hintStyle: const TextStyle(
                        fontFamily: 'PixelFont',
                        color: Colors.grey,
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
              ),
              const SizedBox(height: 20),
              PixelButton(
                text: "Easy",
                onPressed: () {
                  final nickname = _nicknameController.text;
                  if (nickname.isNotEmpty) {
                    widget.onPlay(100, nickname); // Pass speed and nickname
                  }
                },
              ),
              const SizedBox(height: 20),
              PixelButton(
                text: "Medium",
                onPressed: () {
                  final nickname = _nicknameController.text;
                  if (nickname.isNotEmpty) {
                    widget.onPlay(400, nickname); // Pass speed and nickname
                  }
                },
              ),
              const SizedBox(height: 20),
              PixelButton(
                text: "Hard",
                onPressed: () {
                  final nickname = _nicknameController.text;
                  if (nickname.isNotEmpty) {
                    widget.onPlay(700, nickname); // Pass speed and nickname
                  }
                },
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

  const PixelButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

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
            style: const TextStyle(
              fontSize: 32,
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
