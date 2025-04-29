import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  final Widget child;

  const BackgroundGradient({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF5E6C8), // Cream
            Color(0xFFDDB892), // Light Brown
            Color(0xFF7F5539), // Deep Brown
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
