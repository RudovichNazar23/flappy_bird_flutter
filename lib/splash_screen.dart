import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onFinish;

  const SplashScreen({Key? key, required this.onFinish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulate a delay for the splash screen
    Future.delayed(Duration(seconds: 3), onFinish);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/mountains.png',
              fit: BoxFit.cover, // Ensure the image covers the entire screen
            ),
          ),
          Center(
            child: Image.asset('assets/images/KaliopLogo.png'), // Your logo image
          ),
        ],
      ),
    );
  }
}