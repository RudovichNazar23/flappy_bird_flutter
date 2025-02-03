import 'package:flutter/material.dart';

class ResponsiveLayoutHelper {
  static const double minGameWidth = 400.0;
  static const double minGameHeight = 600.0;
  static const double maxGameWidth = 1920.0;
  static const double maxGameHeight = 1080.0;

  static Size getOptimalGameSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;

    if (aspectRatio > 16/9) {

      final height = size.height;
      return Size(height * (16/9), height);
    } else {

      final width = size.width;
      return Size(width, width * (9/16));
    }
  }

  static Size getConstrainedSize(Size size) {
    final width = size.width.clamp(minGameWidth, maxGameWidth);
    final height = size.height.clamp(minGameHeight, maxGameHeight);
    return Size(width, height);
  }

  static double getScaleFactor(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return (size.width / minGameWidth).clamp(0.5, 2.0);
  }
}