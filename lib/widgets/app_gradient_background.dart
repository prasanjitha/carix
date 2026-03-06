import 'package:flutter/material.dart';

class AppGradientBackground extends StatelessWidget {
  final Widget child;
  const AppGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D1117), // Base Dark
            Color(0xFF16213E), // Deep Teal-Blue
            Color(0xFF1A1A1D), // Dark Neutral
          ],
        ),
      ),
      child: Stack(
        children: [
          // වම් පැත්තේ උඩින් පොඩි Teal Glow එකක්
          Positioned(
            top: -100,
            left: -50,
            child: _buildGlow(250, const Color(0xFF2DD4BF).withValues(alpha: 0.1)),
          ),
          // දකුණු පැත්තේ යටින් පොඩි Red/Orange Glow එකක්
          Positioned(
            bottom: -50,
            right: -50,
            child: _buildGlow(300, const Color(0xFFFF4D4D).withValues(alpha: 0.08)),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildGlow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}
