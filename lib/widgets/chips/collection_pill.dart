import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CollectionPill extends StatelessWidget {
  final String label;
  final Widget icon;
  final bool isActive;
  final VoidCallback onTap;

  const CollectionPill({
    super.key,
    required this.label,
    required this.icon,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.gold : Colors.white.withValues(alpha: 0.6),
          border: Border.all(color: isActive ? AppColors.gold : Colors.white.withValues(alpha: 0.8), width: 1.5),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.button.copyWith(
                fontSize: 14,
                color: isActive ? AppColors.mahogany : AppColors.mountain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
