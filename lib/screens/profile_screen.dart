import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'dart:ui';
import 'login_screen.dart';
import 'profile_edit_screen.dart';
import 'wishlist_screen.dart';
import 'organizer/organizer_dashboard_screen.dart';
import '../widgets/images/cached_hero_image.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authProvider);
    final bookingsAsync = ref.watch(userBookingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: authAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load profile')),
        data: (user) {
          final upcomingCount = bookingsAsync.value
                  ?.where((b) => b.status == 'CONFIRMED' || b.status == 'PENDING')
                  .length ??
              0;
          final totalEvents = bookingsAsync.value?.length ?? 0;
          final avatarUrl = user?.profileImageUrl ??
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200';

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                pinned: true,
                expandedHeight: 380,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.cinematicDarkOverlay.withValues(alpha: 0.9), AppColors.background],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: ClipRRect(
                          child: CachedHeroImage(
                            imageUrl: avatarUrl,
                            fit: BoxFit.cover,
                            placeholderIcon: Icons.person,
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
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: CachedHeroImage(
                                  imageUrl: avatarUrl,
                                  fit: BoxFit.cover,
                                  placeholderIcon: Icons.person,
                                ),
                              ),
                            ).animate().scale(delay: 100.ms, duration: 400.ms, curve: Curves.easeOutBack),
                            const SizedBox(height: 24),
                            Text(
                              user != null ? user.displayName : 'Guest',
                              style: AppTextStyles.heroTitle.copyWith(fontSize: 32, color: AppColors.mahogany),
                            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                            const SizedBox(height: 8),
                            if (user != null)
                              Text(
                                user.email,
                                style: AppTextStyles.metadata.copyWith(color: AppColors.mountain),
                              ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
                              ),
                              child: Text(
                                user == null
                                    ? 'GUEST'
                                    : user.isOrganizer
                                        ? 'ORGANIZER'
                                        : 'BOOKMYEVENT MEMBER',
                                style: AppTextStyles.metadata.copyWith(color: AppColors.gold, letterSpacing: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  if (user != null)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.mahogany),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
                      ),
                    ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat('$totalEvents', 'Events'),
                            Container(height: 40, width: 1, color: AppColors.mountain.withValues(alpha: 0.2)),
                            _buildStat('$upcomingCount', 'Upcoming'),
                            Container(height: 40, width: 1, color: AppColors.mountain.withValues(alpha: 0.2)),
                            _buildStat(user?.role ?? '—', 'Role'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      Text('MY ACCOUNT', style: AppTextStyles.metadata.copyWith(color: AppColors.mountain, letterSpacing: 2)),
                      const SizedBox(height: 20),
                      if (user?.isOrganizer == true)
                        _buildListTile(context, Icons.dashboard_outlined, 'Organizer Dashboard', onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const OrganizerDashboardScreen()));
                        }),
                      _buildListTile(context, Icons.bookmark_border, 'Saved Events', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistScreen()));
                      }),
                      _buildListTile(context, Icons.edit_outlined, 'Edit Profile', onTap: () {
                        if (user == null) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileEditScreen()));
                      }),
                      const SizedBox(height: 32),
                      Text('SETTINGS', style: AppTextStyles.metadata.copyWith(color: AppColors.mountain, letterSpacing: 2)),
                      const SizedBox(height: 20),
                      _buildListTile(context, Icons.logout, 'Sign Out', onTap: () async {
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (_) => false,
                          );
                        }
                      }, isDestructive: true),
                      const SizedBox(height: 140),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.heroTitle.copyWith(fontSize: 22, color: AppColors.mahogany)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.metadata.copyWith(color: AppColors.mountain)),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title,
      {VoidCallback? onTap, bool isDestructive = false}) {
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
