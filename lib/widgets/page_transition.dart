import 'package:flutter/material.dart';

class SlideFadeTransition extends PageRouteBuilder {
  final Widget page;

  SlideFadeTransition({required this.page})
      : super(
          pageBuilder: (_, animation, secondaryAnimation) => page,
          transitionsBuilder: (_, animation, _, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              )),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        );
}
