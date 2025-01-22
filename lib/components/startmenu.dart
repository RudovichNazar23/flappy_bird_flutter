import 'package:flutter/material.dart';
import 'dart:io';

class StartMenu extends StatelessWidget {
  final VoidCallback onPlay;

  const StartMenu({required this.onPlay, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF264653),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:AssetImage('assets/images/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PixelContainer(
                child:Padding(
                  padding: const EdgeInsets.all(20.0),
                    child: Text('Flappy Bird',
                      style: TextStyle(
                        fontSize: 54,
                        fontFamily: 'PixelFont',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ),
              const SizedBox(height: 50),
              PixelButton(text: "Play", onPressed: onPlay),
              const SizedBox(height: 20),
              PixelButton(text: "Exit", onPressed: (){exit(0);})
            ],
          ),
        ) ,
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
        color: Colors.green, // Bright green, like the pipes in Flappy Bird
        border: Border.all(
          color: Colors.black, // Black border for strong arcade contrast
          width: 5.0, // Bold border to emphasize pixelated design
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: Offset(6, 6), // No blur to maintain sharp pixelated edges
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