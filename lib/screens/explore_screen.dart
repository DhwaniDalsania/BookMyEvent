import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/event_provider.dart';
import '../providers/navigation_provider.dart';
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
  String _searchQuery = '';
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(searchQueryProvider);
    _searchController = TextEditingController(text: initialQuery);
    _searchQuery = initialQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerQuery = ref.watch(searchQueryProvider);
    if (providerQuery != _searchQuery) {
      _searchQuery = providerQuery;
      _searchController.text = providerQuery;
    }

    final searchAsync = _searchQuery.trim().isNotEmpty
        ? ref.watch(searchResultsProvider(_searchQuery))
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFilterSheet(context),
        backgroundColor: AppColors.mahogany,
        icon: const Icon(Icons.tune, color: AppColors.gold, size: 20),
        label: Text('Filters', style: AppTextStyles.button.copyWith(color: AppColors.gold, fontSize: 14)),
        elevation: 8,
      ),
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
                        CustomSearchBar(
                          controller: _searchController,
                          hintText: 'Search artists, venues, events...',
                          onChanged: (value) {
                            setState(() => _searchQuery = value);
                            ref.read(searchQueryProvider.notifier).state = value;
                          },
                        ),
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
                  if (_searchQuery.isNotEmpty) _buildSearchResults(),

                  // Search Suggestions
                  if (_searchQuery.isEmpty) _buildSearchTags('Trending Searches', _trendingSearches, AppColors.gold),
                  if (_searchQuery.isEmpty) _buildSearchTags('Recent Searches', _recentSearches, AppColors.mountain),
                  
                  const SizedBox(height: 40),

                  if (searchAsync != null)
                    searchAsync.when(
                      data: (results) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader('Search Results', '${results.length} events found'),
                          if (results.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(24),
                              child: Text('No events match your search.', style: TextStyle(color: AppColors.mountain)),
                            )
                          else
                            ...results.map((e) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  child: CompactEventCard(
                                    event: e,
                                    onTap: () => _navigateToDetails(context, e),
                                  ),
                                )),
                          const SizedBox(height: 48),
                        ],
                      ),
                      loading: () => const Padding(
                        padding: EdgeInsets.all(48),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Search failed: $e'),
                      ),
                    ),

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

  Widget _buildSearchResults() {
    final resultsAsync = ref.watch(searchEventsProvider(_searchQuery));
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: resultsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return Text('No events found for "$_searchQuery"',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Search Results', style: AppTextStyles.sectionHeader.copyWith(color: AppColors.mahogany, fontSize: 20)),
              const SizedBox(height: 16),
              ...events.take(10).map((event) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CompactEventCard(
                      event: event,
                      onTap: () => _navigateToDetails(context, event),
                    ),
                  )),
            ],
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Text('Search failed: $e', style: const TextStyle(color: Colors.red)),
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
            children: tags.map((tag) => GestureDetector(
              onTap: () {
                setState(() {
                  _searchQuery = tag;
                  _searchController.text = tag;
                });
                ref.read(searchQueryProvider.notifier).state = tag;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.mountain.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(title.contains('Trending') ? Icons.trending_up : Icons.history, color: accentColor, size: 14),
                    const SizedBox(width: 6),
                    Text(tag, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mahogany, fontSize: 13)),
                  ],
                ),
              ),
            )).toList(),
          ),
        ],
      ),
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
    );
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
              );
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
              );
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
              );
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
                  onTap: () {
                    ref.invalidate(eventsProvider(categories[index].slug));
                  },
                  imageUrl: categories[index].iconUrl ?? 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?q=80&w=400&auto=format&fit=crop',
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
      error: (e, s) => const SizedBox.shrink(),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.mountain.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Quick Filters', 
              style: AppTextStyles.sectionHeader.copyWith(
                color: AppColors.mahogany,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse events by category instantly.',
              style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mountain),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ['Concerts', 'Comedy', 'Sports', 'Festivals', 'Theatre'].map((tag) {
                final isCurrent = _searchQuery == tag;
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _searchQuery = tag;
                      _searchController.text = tag;
                    });
                    ref.read(searchQueryProvider.notifier).state = tag;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isCurrent ? AppColors.mahogany : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCurrent ? AppColors.mahogany : AppColors.sand,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cinematicShadow.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      tag,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isCurrent ? AppColors.gold : AppColors.mahogany,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
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
