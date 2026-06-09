import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'login_screen.dart';
import '../widgets/images/cached_hero_image.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Discover\nGreat Events',
      'description': 'Find the best concerts, shows, and immersive experiences happening in your city.',
      'image': 'https://images.unsplash.com/photo-1540039155732-d68f126d40ee?q=80&w=800&auto=format&fit=crop'
    },
    {
      'title': 'Seamless\nBooking',
      'description': 'Secure your spot instantly. Enjoy a fast, premium, and reliable checkout experience.',
      'image': 'https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?q=80&w=800&auto=format&fit=crop'
    },
    {
      'title': 'Curated\nFor You',
      'description': 'Get tailored recommendations based on your unique taste in entertainment.',
      'image': 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=800&auto=format&fit=crop'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Full bleed Background imagery
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  CachedHeroImage(
                    imageUrl: _onboardingData[index]['image']!,
                    fit: BoxFit.cover,
                    fallbackAsset: 'assets/images/placeholder_hero.jpg',
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.background,
                          AppColors.background.withValues(alpha: 0.8),
                          AppColors.cinematicDarkOverlay.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Content overlay
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.vanilla.withValues(alpha: 0.95), // Solid opaque fallback for performance
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _onboardingData[_currentPage]['title']!,
                              style: AppTextStyles.heroTitle.copyWith(color: AppColors.mahogany, fontSize: 36, height: 1.1),
                            ).animate(key: ValueKey(_currentPage)).fadeIn(duration: 400.ms).slideX(begin: 0.1),
                            const SizedBox(height: 16),
                            Text(
                              _onboardingData[_currentPage]['description']!,
                              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mountain),
                            ).animate(key: ValueKey('desc_$_currentPage')).fadeIn(delay: 200.ms, duration: 400.ms).slideX(begin: 0.1),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: List.generate(
                                    _onboardingData.length,
                                    (index) => AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.only(right: 6),
                                      width: _currentPage == index ? 24 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _currentPage == index
                                            ? AppColors.mahogany
                                            : AppColors.mountain.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_currentPage == _onboardingData.length - 1) {
                                      Future.delayed(const Duration(milliseconds: 200), () {
                                        if (!context.mounted) return;
                                        Navigator.of(context).pushReplacement(
                                          PageRouteBuilder(
                                            pageBuilder: (context, a, b) => const LoginScreen(),
                                            transitionsBuilder: (context, animation, b, child) => FadeTransition(opacity: animation, child: child),
                                            transitionDuration: const Duration(milliseconds: 800),
                                          ),
                                        );
                                      });
                                    } else {
                                      _pageController.nextPage(
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.easeOutCubic,
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: AppColors.mahogany,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.mahogany.withValues(alpha: 0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        )
                                      ],
                                    ),
                                    child: Icon(
                                      _currentPage == _onboardingData.length - 1 ? Icons.check : Icons.arrow_forward,
                                      color: AppColors.gold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

