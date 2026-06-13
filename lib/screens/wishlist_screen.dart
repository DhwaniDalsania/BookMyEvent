import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'event_details_screen.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/images/cached_hero_image.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'My Wishlist',
          style: AppTextStyles.sectionHeader.copyWith(
            color: AppColors.mahogany,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: wishlistAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_border_outlined, size: 64, color: AppColors.mountain),
                    const SizedBox(height: 16),
                    Text(
                      'Your wishlist is empty',
                      style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Explore events and save your favorites here.",
                      style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mountain),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                  margin: const EdgeInsets.only(bottom: 16.0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cinematicShadow.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedHeroImage(
                          imageUrl: event.heroImageUrl ?? '',
                          width: 80,
                          height: 80,
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
                                  child: Text(
                                    event.title, 
                                    style: AppTextStyles.cardTitle.copyWith(
                                      color: AppColors.mahogany,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.favorite, color: AppColors.gold, size: 20),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.description, 
                              style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mountain, fontSize: 13), 
                              maxLines: 1, 
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${DateFormat('MMM d').format(event.startTime)} • ${event.locationName}',
                                    style: AppTextStyles.metadata.copyWith(color: AppColors.mountain),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.gold.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '₹${event.startingPrice.toInt()}+', 
                                    style: AppTextStyles.metadata.copyWith(
                                      color: AppColors.mahogany, 
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.mahogany)),
        error: (e, s) => Center(child: Text('Error: $e', style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mahogany))),
      ),
    );
  }
}

