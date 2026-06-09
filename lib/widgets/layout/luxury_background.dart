import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class LuxuryBackground extends StatelessWidget {
  final Widget child;

  const LuxuryBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.vanillaDark,
      ),
      child: Stack(
        children: [
          // Background Base Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFAF7F2), // Very light warm beige
                  Color(0xFFE5DBC7), // Vanilla Dark
                ],
              ),
            ),
          ),
          // Top Right Glow (Gold/Warm)
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gold.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Bottom Left Glow (Deep Tobacco)
          Positioned(
            bottom: -200,
            left: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.tobacco.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Subtle Grid/Noise overlay (Optional, but adds texture)
          // We can use a subtle pattern or just leave the glows for a clean luxury feel.

          // Main Content
          SafeArea(
            bottom: false,
            child: child,
          ),
        ],
      ),
    );
  }
}
