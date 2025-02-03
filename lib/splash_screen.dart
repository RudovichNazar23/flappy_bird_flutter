import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onFinish;

  const SplashScreen({Key? key, required this.onFinish}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 3), onFinish);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/mountains.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Image.asset('assets/images/KaliopLogo.png'),
          ),
        ],
      ),
    );
  }
}