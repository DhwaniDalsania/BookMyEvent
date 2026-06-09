import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final Map<String, dynamic> category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  dynamic _getIcon(String iconName) {
    switch (iconName) {
      case 'music': return FontAwesomeIcons.music;
      case 'microphone': return FontAwesomeIcons.microphone;
      case 'briefcase': return FontAwesomeIcons.briefcase;
      case 'volleyball': return FontAwesomeIcons.volleyball;
      case 'masks-theater': return FontAwesomeIcons.masksTheater;
      default: return FontAwesomeIcons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tobacco : AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.tobacco : AppColors.mountain.withValues(alpha: 0.3),
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.tobacco.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              _getIcon(category['icon']),
              size: 14,
              color: isSelected ? Colors.white : AppColors.mahogany,
            ),
            const SizedBox(width: 8),
            Text(
              category['name'],
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : AppColors.mahogany,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
