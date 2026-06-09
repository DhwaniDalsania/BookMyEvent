import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'dart:ui';
import 'login_screen.dart';

import '../widgets/images/cached_hero_image.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Premium Header
          SliverAppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            pinned: true,
            expandedHeight: 380,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Abstract luxury gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.cinematicDarkOverlay.withValues(alpha: 0.9), AppColors.background],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Background Image Blur
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: const CachedHeroImage(
                        imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        fallbackAsset: 'assets/images/placeholder_profile.jpg',
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.background,
                              AppColors.background.withValues(alpha: 0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Profile Content
                  Positioned(
                    bottom: 40,
                    left: 24,
                    right: 24,
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gold, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withValues(alpha: 0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: const CachedHeroImage(
                              imageUrl: 'https://images.unsplash.com/photo-1540039155732-d68f126d40ee?q=80&w=600&auto=format&fit=crop', // Mock past event
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              fallbackAsset: 'assets/images/placeholder_hero.jpg',
                            ),
                          ),
                        ).animate().scale(delay: 100.ms, duration: 400.ms, curve: Curves.easeOutBack),
                        const SizedBox(height: 24),
                        ref.watch(authProvider).when(
                           data: (user) => Text(
                             user != null
                                 ? '${user.firstName} ${user.lastName}'
                                 : 'Guest',
                             style: AppTextStyles.heroTitle
                                 .copyWith(fontSize: 32, color: AppColors.mahogany),
                           ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                           loading: () => const Center(child: CircularProgressIndicator()),
                           error: (error, _) => const Text('Error loading profile'),
                         ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
                          ),
                          child: Text('BOOKMYEVENT VIP MEMBER', style: AppTextStyles.metadata.copyWith(color: AppColors.gold, letterSpacing: 1.5)),
                        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: AppColors.mahogany),
                onPressed: () {},
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cinematicShadow.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('12', 'Events'),
                        Container(height: 40, width: 1, color: AppColors.mountain.withValues(alpha: 0.2)),
                        _buildStat('3', 'Upcoming'),
                        Container(height: 40, width: 1, color: AppColors.mountain.withValues(alpha: 0.2)),
                        _buildStat('Top 5%', 'Fan'),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                  const SizedBox(height: 48),

                  // Practical Sections
                  Text('MY ACCOUNT', style: AppTextStyles.metadata.copyWith(color: AppColors.mountain, letterSpacing: 2))
                    .animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 20),
                  
                  _buildListTile(context, Icons.bookmark_border, 'Saved Events'),
                  _buildListTile(context, Icons.history, 'Recently Viewed'),
                  _buildListTile(context, Icons.tune, 'Preferences'),
                  
                  const SizedBox(height: 32),
                  
                  Text('SETTINGS', style: AppTextStyles.metadata.copyWith(color: AppColors.mountain, letterSpacing: 2))
                    .animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: 20),
                  
                  _buildListTile(context, Icons.payment_outlined, 'Payment Methods'),
                  _buildListTile(context, Icons.settings_outlined, 'Account Settings'),
                  _buildListTile(context, Icons.support_agent_outlined, 'Support & Help'),
                  _buildListTile(context, Icons.logout, 'Sign Out', onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
                  }, isDestructive: true),

                  const SizedBox(height: 140), // Padding for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.heroTitle.copyWith(fontSize: 28, color: AppColors.mahogany)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.metadata.copyWith(color: AppColors.mountain)),
      ],
    );
  }



  Widget _buildListTile(BuildContext context, IconData icon, String title, {VoidCallback? onTap, bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDestructive ? Colors.red.withValues(alpha: 0.1) : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: isDestructive ? Colors.red : AppColors.mahogany, size: 22),
                ),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: AppTextStyles.bodyCopy.copyWith(
                    color: isDestructive ? Colors.red : AppColors.mahogany,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Icon(Icons.chevron_right, color: AppColors.mountain.withValues(alpha: 0.5), size: 20),
          ],
        ),
      ),
    );
  }
}

