import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

enum BadgeType { trending, soldFast, limited, newRelease }

class LuxuryBadge extends StatelessWidget {
  final BadgeType type;

  const LuxuryBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (type) {
      case BadgeType.trending:
        backgroundColor = AppColors.gold;
        textColor = AppColors.mahogany;
        label = 'TRENDING';
        break;
      case BadgeType.soldFast:
        backgroundColor = AppColors.mahogany;
        textColor = AppColors.vanilla;
        label = 'SOLD FAST';
        break;
      case BadgeType.limited:
        backgroundColor = const Color(0xFF4A2511); // Deep red-brown
        textColor = AppColors.vanilla;
        label = 'LIMITED';
        break;
      case BadgeType.newRelease:
        backgroundColor = AppColors.tobacco;
        textColor = AppColors.mahogany;
        label = 'NEW';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.metadata.copyWith(
          color: textColor,
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
