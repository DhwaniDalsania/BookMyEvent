import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'onboarding_screen.dart';
import '../widgets/images/cached_hero_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 1000),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const CachedHeroImage(
            imageUrl: 'https://images.unsplash.com/photo-1540039155732-d68f126d40ee?q=80&w=600&auto=format&fit=crop',
            fit: BoxFit.cover,
            fallbackAsset: 'assets/images/placeholder_hero.jpg',
          ),
          Container(
            color: AppColors.cinematicDarkOverlay.withValues(alpha: 0.8),
          ),
          
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gold.withValues(alpha: 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      )
                    ],
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.3), width: 2),
                  ),
                  child: const Icon(
                    Icons.event_seat,
                    size: 60,
                    color: AppColors.gold,
                  ),
                ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                 .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 2.seconds, curve: Curves.easeInOut),
                const SizedBox(height: 32),
                Text(
                  'BookMyEvent',
                  style: AppTextStyles.heroTitle.copyWith(
                    color: Colors.white,
                    fontSize: 48,
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 800.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: 8),
                Text(
                  'PREMIUM EXPERIENCES',
                  style: AppTextStyles.metadata.copyWith(color: AppColors.gold, letterSpacing: 4),
                ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

