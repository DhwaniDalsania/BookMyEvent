import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'bookings_screen.dart';
import 'profile_screen.dart';
import '../widgets/navigation/floating_nav_bar.dart';
import '../providers/navigation_provider.dart';

class MainLayout extends ConsumerWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    final screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const BookingsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.vanilla,
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: screens,
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: FloatingNavBar(
                  currentIndex: currentIndex,
                  onTap: (index) {
                    ref.read(navigationIndexProvider.notifier).state = index;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

