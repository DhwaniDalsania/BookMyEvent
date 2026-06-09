import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/event_provider.dart';
import '../data/models/event_model.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/inputs/custom_search_bar.dart';
import '../widgets/cards/event_card.dart';
import '../widgets/cards/category_card.dart';
import 'event_details_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final List<String> _trendingSearches = ['Coldplay', 'Stand-up Comedy', 'Music Festivals', 'Arijit Singh'];
  final List<String> _recentSearches = ['Mumbai City FC', 'Lollapalooza', 'Pottery Workshop'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.mahogany,
        icon: const Icon(Icons.tune, color: AppColors.gold, size: 20),
        label: Text('Filters', style: AppTextStyles.button.copyWith(color: AppColors.gold, fontSize: 14)),
        elevation: 8,
      ).animate().fadeIn(delay: 800.ms).slideY(begin: 1.0),
      body: CustomScrollView(
        slivers: [
          // Premium Search Hero
          SliverAppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            floating: false,
            pinned: true,
            expandedHeight: 280,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.cinematicDarkOverlay, AppColors.background],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.gold, size: 20),
                            const SizedBox(width: 8),
                            Text('Mumbai, IN', style: AppTextStyles.metadata.copyWith(color: Colors.white, fontSize: 14)),
                            const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text('Find your next', style: AppTextStyles.heroTitle.copyWith(fontSize: 32, color: Colors.white, height: 1.1)),
                        Text('Experience', style: AppTextStyles.heroTitle.copyWith(fontSize: 32, color: AppColors.gold, height: 1.1)),
                        const SizedBox(height: 24),
                        const CustomSearchBar(hintText: 'Search artists, venues, events...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Suggestions
                  _buildSearchTags('Trending Searches', _trendingSearches, AppColors.gold),
                  _buildSearchTags('Recent Searches', _recentSearches, AppColors.mountain),
                  
                  const SizedBox(height: 40),

                  // Trending Events Carousel
                  _buildSectionHeader('Trending Events', 'Most popular right now'),
                  _buildTrendingCarousel(),

                  const SizedBox(height: 48),

                  // Categories Grid
                  _buildSectionHeader('Browse Categories', 'Find exactly what you want'),
                  _buildCategories(),

                  const SizedBox(height: 48),

                  // This Weekend Carousel
                  _buildSectionHeader('This Weekend', 'Top picks for the next 48 hours'),
                  _buildWeekendCarousel(),

                  const SizedBox(height: 48),

                  // Premium Experiences
                  _buildSectionHeader('Premium Experiences', 'Exclusive luxury events'),
                  _buildPremiumCarousel(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTags(String title, List<String> tags, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.metadata.copyWith(color: AppColors.mountain, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(title.contains('Trending') ? Icons.trending_up : Icons.history, color: accentColor, size: 14),
                  const SizedBox(width: 6),
                  Text(tag, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70, fontSize: 13)),
                ],
              ),
            )).toList(),
          ),
        ],
      ).animate().fadeIn().slideY(begin: 0.1),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.sectionHeader.copyWith(color: AppColors.mahogany, fontSize: 24)),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain)),
              ],
            ),
          ),
          Text('See All', style: AppTextStyles.button.copyWith(color: AppColors.gold, fontSize: 13)),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.05);
  }

  Widget _buildTrendingCarousel() {
    final eventsAsync = ref.watch(featuredEventsProvider);

    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) return const SizedBox(height: 400, child: Center(child: Text('No trending events.', style: TextStyle(color: Colors.white))));
        return SizedBox(
          height: 400,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 280,
                  child: FeatureEventCard(
                    event: events[index],
                    onTap: () => _navigateToDetails(context, events[index]),
                  ),
                ),
              ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1);
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 400, child: Center(child: CircularProgressIndicator())),
      error: (e, s) => SizedBox(height: 400, child: Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red)))),
    );
  }

  Widget _buildWeekendCarousel() {
    final eventsAsync = ref.watch(eventsProvider(null));

    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: events.length > 5 ? 5 : events.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 300,
                  child: HeroEventCard(
                    event: events[index],
                    onTap: () => _navigateToDetails(context, events[index]),
                  ),
                ),
              ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1);
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 280, child: Center(child: CircularProgressIndicator())),
      error: (e, s) => const SizedBox.shrink(),
    );
  }

  Widget _buildPremiumCarousel() {
    final eventsAsync = ref.watch(eventsProvider(null));

    return eventsAsync.when(
      data: (events) {
        final premiumEvents = events.where((e) => e.startingPrice > 2500).toList();
        if (premiumEvents.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 380,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: premiumEvents.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 260,
                  child: FeatureEventCard(
                    event: premiumEvents[index],
                    onTap: () => _navigateToDetails(context, premiumEvents[index]),
                  ),
                ),
              ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1);
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 380, child: Center(child: CircularProgressIndicator())),
      error: (e, s) => const SizedBox.shrink(),
    );
  }

  Widget _buildCategories() {
    final catsAsync = ref.watch(categoriesProvider);

    return catsAsync.when(
      data: (categories) {
        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CategoryCard(
                  category: { 'name': categories[index].name, 'icon': categories[index].iconUrl ?? '🎤' }, // mapping to existing ui struct
                  isActive: false,
                  onTap: () {},
                  imageUrl: categories[index].iconUrl ?? 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?q=80&w=400&auto=format&fit=crop',
                ),
              ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1);
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
      error: (e, s) => const SizedBox.shrink(),
    );
  }

  void _navigateToDetails(BuildContext context, EventModel event) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => EventDetailsScreen(event: event),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
