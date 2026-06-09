import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/buttons/glass_button.dart';
import 'seat_selection_screen.dart';
import '../widgets/cards/event_card.dart';
import '../data/models/event_model.dart';
import 'package:intl/intl.dart';
import '../widgets/images/cached_hero_image.dart';
import '../providers/event_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/wishlist_provider.dart';
import '../data/repositories/wishlist_repository.dart';
import 'login_screen.dart';
import '../widgets/buttons/primary_button.dart';

class EventDetailsScreen extends ConsumerWidget {
  final EventModel event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEventsAsync = ref.watch(eventsProvider(null));
    final wishlistIds = ref.watch(wishlistIdsProvider);
    final isSaved = wishlistIds.value?.contains(event.id) ?? false;
    final List<EventModel> similarEvents = allEventsAsync.value
        ?.where((e) => e.id != event.id && e.categoryId == event.categoryId)
        .take(5)
        .toList() ?? [];

    return Scaffold(
      backgroundColor: AppColors.cinematicOverlay,
      body: Stack(
        children: [
          // 1. Edge-to-Edge Background Image
          Positioned.fill(
            child: CachedHeroImage(
              imageUrl: event.heroImageUrl ?? 'https://images.unsplash.com/photo-1540039155732-d68f126d40ee?q=80&w=600&auto=format&fit=crop',
              fit: BoxFit.cover,
              fallbackAsset: 'assets/images/placeholder_hero.jpg',
            ),
          ),
          
          // 2. Cinematic Gradient Overlays (Netflix style)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.cinematicOverlay.withValues(alpha: 1.0),
                    AppColors.cinematicOverlay.withValues(alpha: 0.8),
                    AppColors.cinematicOverlay.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // 3. Scrollable Content
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.45, // Wait to show content until lower
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GlassButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GlassButton(
                      icon: isSaved ? Icons.favorite : Icons.favorite_border,
                      onTap: () async {
                        final user = ref.read(authProvider).value;
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please sign in to save events')),
                          );
                          return;
                        }
                        try {
                          final repo = ref.read(wishlistRepositoryProvider);
                          if (isSaved) {
                            await repo.removeFromWishlist(event.id);
                          } else {
                            await repo.addToWishlist(event.id);
                          }
                          ref.invalidate(wishlistProvider);
                          ref.invalidate(wishlistIdsProvider);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Wishlist error: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Meta
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          child: Text(
                              event.categoryName.toUpperCase(),
                              style: AppTextStyles.metadata.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('MMM d').format(event.startTime).toUpperCase(),
                            style: AppTextStyles.metadata.copyWith(color: Colors.white, fontSize: 13, letterSpacing: 2),
                          ),
                        ],
                      ).animate().fadeIn().slideY(begin: 0.2),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        event.title,
                        style: AppTextStyles.heroTitle.copyWith(color: Colors.white, fontSize: 48),
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
                      
                      const SizedBox(height: 32),
                      
                      // Floating Glass Panel for Details
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.gold.withValues(alpha: 0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.location_on, color: AppColors.gold),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.locationName,
                                            style: AppTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 18),
                                          ),
                                          Text(
                                            event.locationName,
                                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Divider(color: Colors.white24, height: 1),
                                ),
                                Text('About', style: AppTextStyles.sectionHeader.copyWith(color: Colors.white, fontSize: 24)),
                                const SizedBox(height: 12),
                                  Text(
                                    event.description.isNotEmpty ? event.description : 'Experience the biggest event of the year with exclusive performances and a vibrant atmosphere.',
                                    style: AppTextStyles.bodyCopy.copyWith(color: AppColors.vanilla.withValues(alpha: 0.8), height: 1.6),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

                      const SizedBox(height: 40),

                      Text('Lineup', style: AppTextStyles.sectionHeader.copyWith(color: Colors.white)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildLineupAvatar('https://images.unsplash.com/photo-1520635360276-73f340431b61?q=80&w=150&auto=format&fit=crop'),
                          _buildLineupAvatar('https://images.unsplash.com/photo-1516280440502-86105f8841a0?q=80&w=150&auto=format&fit=crop'),
                          _buildLineupAvatar('https://images.unsplash.com/photo-1493225457124-a1a2a5f5f9af?q=80&w=150&auto=format&fit=crop'),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.gold, width: 1.5),
                            ),
                            child: const Center(child: Text('+3', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold))),
                          ),
                        ],
                      ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: 48),

                      if (similarEvents.isNotEmpty) ...[
                        Text('Similar Events', style: AppTextStyles.sectionHeader.copyWith(color: Colors.white)),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 280,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: similarEvents.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: FeatureEventCard(
                                  isCompactHeight: true,
                                  event: similarEvents[index],
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => EventDetailsScreen(event: similarEvents[index]),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          return FadeTransition(opacity: animation, child: child);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 140), // Spacing for floating button
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 4. Floating Massive CTA
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        final user = ref.read(authProvider).value;
                        if (user == null) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Sign in required'),
                              content: const Text('Please sign in to book tickets for this event.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                                  },
                                  child: const Text('Sign In'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }
                        _showQuantitySelector(context, ref);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'BOOK TICKETS',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.mahogany, 
                              fontWeight: FontWeight.w900, 
                              fontSize: 18, 
                              letterSpacing: 2
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.mahogany,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '₹${event.startingPrice.toInt()}',
                              style: AppTextStyles.button.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ).animate().slideY(begin: 1.0, curve: Curves.easeOutExpo, duration: 800.ms),
        ],
      ),
    );
  }

  Widget _buildLineupAvatar(String url) {
    return Align(
      widthFactor: 0.8,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: ClipOval(
          child: Image.network(
            url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) { if (loadingProgress == null) return child; return Container(color: Colors.grey[900], child: const Center(child: CircularProgressIndicator(color: Colors.white24, strokeWidth: 2))); }, errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/placeholder_profile.jpg', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  void _showQuantitySelector(BuildContext context, WidgetRef ref) {
    int quantity = 2;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.vanilla,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Ticket Quantity',
                    style: AppTextStyles.sectionHeader.copyWith(color: AppColors.mahogany),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Choose how many seats you want to book for ${event.title}',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (quantity > 1) {
                            setModalState(() => quantity--);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gold, width: 2),
                          ),
                          child: const Icon(Icons.remove, color: AppColors.mahogany),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Text(
                        '$quantity',
                        style: AppTextStyles.heroTitle.copyWith(color: AppColors.mahogany, fontSize: 36),
                      ),
                      const SizedBox(width: 32),
                      GestureDetector(
                        onTap: () {
                          if (quantity < 10) {
                            setModalState(() => quantity++);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gold, width: 2),
                          ),
                          child: const Icon(Icons.add, color: AppColors.mahogany),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: PrimaryButton(
                      text: 'Select Seats',
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SeatSelectionScreen(
                              event: event,
                              ticketCount: quantity,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
