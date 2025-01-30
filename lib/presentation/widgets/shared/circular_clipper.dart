import 'dart:ui';

import 'package:flutter/material.dart';

class CircularClipper extends CustomClipper<Rect> {
  final double size;

  CircularClipper(this.size);

  @override
  Rect getClip(Size screenSize) {
    double centerX = screenSize.width / 2;
    double centerY = screenSize.height / 2;

    double maxRadius = screenSize.longestSide * size; // 🔥 Usa longestSide para expandirse más

    return Rect.fromCircle(center: Offset(centerX, centerY), radius: maxRadius);
  }

  @override
  bool shouldReclip(CircularClipper oldClipper) => oldClipper.size != size;
}
