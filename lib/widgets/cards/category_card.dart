import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../images/cached_hero_image.dart';

class CategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  final bool isActive;
  final VoidCallback onTap;
  final String imageUrl;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isActive,
    required this.onTap,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 400.ms,
        curve: Curves.easeOutCubic,
        width: isActive ? 180 : 120,
        height: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isActive ? 40 : 100),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              )
            else
              BoxShadow(
                color: AppColors.cinematicShadow.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isActive ? 40 : 100),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedHeroImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                fallbackAsset: 'assets/images/placeholder_${category['name'].toString().toLowerCase().replaceAll(' ', '_')}.jpg',
              ),
              // Dynamic Overlay
              AnimatedContainer(
                duration: 400.ms,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: isActive
                        ? [
                            AppColors.cinematicDarkOverlay.withValues(alpha: 0.9),
                            AppColors.gold.withValues(alpha: 0.4),
                          ]
                        : [
                            AppColors.cinematicDarkOverlay.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    category['name'].toString().toUpperCase(),
                    style: AppTextStyles.heroTitle.copyWith(
                      color: Colors.white,
                      fontSize: isActive ? 24 : 14,
                      letterSpacing: isActive ? 2 : 1,
                    ),
                    textAlign: TextAlign.center,
                  ).animate(target: isActive ? 1 : 0).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 300.ms),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
