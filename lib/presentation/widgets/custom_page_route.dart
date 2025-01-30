import 'package:flutter/material.dart';
import 'package:dnero_app_prueba/presentation/widgets/shared/circular_clipper.dart';

// Custom route for circular transition animation
class CircularRevealRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Offset center; // Center position for the animation

  CircularRevealRoute({
    required this.page,
    required this.center,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 1500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            double size = Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(animation);

            return ClipPath(
              clipper: CircularClipper(size, center),
              child: Transform.scale(
                scale: size, // Ensures a smooth scaling animation
                child: child,
              ),
            );
          },
        );
}
