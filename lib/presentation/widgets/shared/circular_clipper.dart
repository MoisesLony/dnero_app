import 'package:flutter/material.dart';

/// Custom clipper for circular reveal animation
class CircularClipper extends CustomClipper<Path> {
  final double size;
  final Offset center;

  CircularClipper(this.size, this.center);

  @override
  Path getClip(Size size) { // ✅ Must match the overridden method
    return Path()
      ..addOval(Rect.fromCircle(
        center: center,
        radius: size.longestSide * this.size, // Expands to the longest screen side
      ));
  }

  @override
  bool shouldReclip(CircularClipper oldClipper) => oldClipper.size != size;
}
