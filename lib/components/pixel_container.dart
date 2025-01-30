import 'package:flutter/material.dart';

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