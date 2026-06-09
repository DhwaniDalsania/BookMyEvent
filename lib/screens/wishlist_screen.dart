import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/layout/luxury_background.dart';
import 'event_details_screen.dart';
import '../providers/wishlist_provider.dart';
import 'dart:ui';
import '../widgets/images/cached_hero_image.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('My Wishlist'),
        centerTitle: false,
      ),
      body: LuxuryBackground(
        child: wishlistAsync.when(
          data: (events) {
            if (events.isEmpty) {
              return Center(
                child: Text(
                  'Your wishlist is empty.',
                  style: AppTextStyles.cardTitle.copyWith(color: AppColors.mountain),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event)),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cinematicShadow.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.vanilla.withValues(alpha: 0.8),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedHeroImage(
                                  imageUrl: event.heroImageUrl ?? 'https://images.unsplash.com/photo-1540039155732-d68f126d40ee?q=80&w=600&auto=format&fit=crop',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  fallbackAsset: 'assets/images/placeholder_hero.jpg',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(event.title, style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany)),
                                        ),
                                        const Icon(Icons.favorite, color: AppColors.mahogany, size: 24),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(event.description, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    const SizedBox(height: 12),
                                    Text(
                                      '${DateFormat('MMM d').format(event.startTime)} • ${event.locationName}',
                                      style: AppTextStyles.metadata.copyWith(color: AppColors.mountain),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.gold.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text('₹${event.startingPrice.toInt()} onwards', style: AppTextStyles.metadata.copyWith(color: AppColors.tobacco, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

