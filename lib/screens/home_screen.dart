import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/event_provider.dart';
import '../data/models/event_model.dart';
import 'dart:ui';
import 'dart:async';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';
import '../providers/navigation_provider.dart';
import '../theme/app_text_styles.dart';
import '../widgets/cards/event_card.dart';
import '../widgets/cards/category_card.dart';
import '../widgets/buttons/glass_button.dart';
import '../widgets/images/cached_hero_image.dart';
import 'event_details_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late PageController _heroController;
  final ScrollController _scrollController = ScrollController();
  int _currentHeroPage = 0;
  int _activeCategoryIndex = 0;
  String? _selectedCategorySlug;
  Timer? _heroTimer;

  @override
  void initState() {
    super.initState();
    _heroController = PageController();
    _heroTimer = Timer.periodic(const Duration(seconds: 5), (_) => _autoScrollHero());
  }

  void _autoScrollHero() {
    if (!mounted) return;
    if (_heroController.hasClients) {
      int nextPage = _currentHeroPage + 1;
      final heroCount = ref.read(featuredEventsProvider).value?.length ?? 0;
      if (heroCount == 0) return;
      if (nextPage >= heroCount) {
        nextPage = 0;
      }
      _heroController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featuredAsync = ref.watch(featuredEventsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final eventsAsync = ref.watch(eventsProvider(_selectedCategorySlug));

    // Fallbacks while loading
    final List<EventModel> heroEvents = featuredAsync.value?.take(3).toList() ?? [];
    final List<EventModel> topPicks = eventsAsync.value?.take(4).toList() ?? [];
    final List<EventModel> trendingEvents = eventsAsync.value?.where((e) => e.isTrending).toList() ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 1. Cinematic Hero Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.75, // 75% of screen
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _heroController,
                    onPageChanged: (index) => setState(() => _currentHeroPage = index),
                    itemCount: heroEvents.length,
                    itemBuilder: (context, index) {
                      final event = heroEvents[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => EventDetailsScreen(event: event),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                              transitionDuration: const Duration(milliseconds: 600),
                            ),
                          );
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedHeroImage(
                              imageUrl: event.heroImageUrl ?? 'https://images.unsplash.com/photo-1540039155732-d68f126d40ee?q=80&w=600&auto=format&fit=crop',
                              fit: BoxFit.cover,
                              fallbackAsset: 'assets/images/placeholder_hero.jpg',
                            ),
                            // Vignette overlay
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    AppColors.cinematicDarkOverlay.withValues(alpha: 0.95),
                                    AppColors.cinematicDarkOverlay.withValues(alpha: 0.2),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 120,
                              left: 32,
                              right: 32,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.gold, width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'PREMIERE',
                                          style: AppTextStyles.metadata.copyWith(color: AppColors.gold, letterSpacing: 2),
                                        ),
                                      ),
                                    ],
                                  ).animate().fadeIn().slideY(begin: 0.2),
                                  const SizedBox(height: 20),
                                  Text(
                                    event.title,
                                    style: AppTextStyles.heroTitle.copyWith(
                                      color: Colors.white,
                                      fontSize: 60,
                                      height: 1.05,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: AppColors.vanilla, size: 16),
                                      const SizedBox(width: 8),
                                      Text(
                                        event.locationName.toUpperCase(),
                                        style: AppTextStyles.metadata.copyWith(color: AppColors.vanilla, fontSize: 13),
                                      ),
                                      const SizedBox(width: 16),
                                      Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle)),
                                      const SizedBox(width: 16),
                                      Text(
                                        DateFormat('MMM d').format(event.startTime).toUpperCase(),
                                        style: AppTextStyles.metadata.copyWith(color: AppColors.vanilla, fontSize: 13),
                                      ),
                                    ],
                                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  // Top Navigation Actions
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 24,
                    right: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Ticketmaster_logo.svg/1200px-Ticketmaster_logo.svg.png', // Temporary placeholder for premium branding
                          height: 24,
                          color: Colors.white,
                          loadingBuilder: (context, child, loadingProgress) { if (loadingProgress == null) return child; return Container(color: Colors.grey[900], child: const Center(child: CircularProgressIndicator(color: Colors.white24, strokeWidth: 2))); }, errorBuilder: (context, error, stackTrace) => const Text('BOOKMYEVENT', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 3)),
                        ),
                        GlassButton(
                          icon: Icons.person,
                          onTap: () => ref.read(navigationIndexProvider.notifier).state = 3,
                          size: 48,
                        ),
                      ],
                    ),
                  ),

                  // Carousel Indicators & Floating Button
                  Positioned(
                    bottom: 40,
                    left: 32,
                    right: 32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: List.generate(
                            heroEvents.length,
                            (index) => AnimatedContainer(
                              duration: 400.ms,
                              margin: const EdgeInsets.only(right: 8),
                              height: 4,
                              width: _currentHeroPage == index ? 32 : 12,
                              decoration: BoxDecoration(
                                color: _currentHeroPage == index ? AppColors.gold : Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (heroEvents.isNotEmpty) {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      EventDetailsScreen(event: heroEvents[_currentHeroPage]),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                                      FadeTransition(opacity: animation, child: child),
                                  transitionDuration: const Duration(milliseconds: 600),
                                ),
                              );
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                ),
                                child: Text('VIEW EVENT', style: AppTextStyles.button.copyWith(color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 64)),

          // 2. Curated Experiences (Editorial Style)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Curated for you', style: AppTextStyles.metadata.copyWith(color: AppColors.gold, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  Text('Exceptional\nExperiences', style: AppTextStyles.sectionHeader.copyWith(color: AppColors.mahogany, fontSize: 40, height: 1.1)),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 480,
              child: eventsAsync.when(
                data: (_) {
                  if (topPicks.isEmpty) return const Center(child: Text('No events found', style: TextStyle(color: Colors.white)));
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    itemCount: topPicks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: FeatureEventCard(
                          event: topPicks[index],
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailsScreen(event: topPicks[index])));
                          },
                        ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e,s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),

          // 3. Category Carousel
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: categoriesAsync.when(
                data: (categories) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return CategoryCard(
                      category: {'id': cat.id, 'name': cat.name},
                      isActive: _activeCategoryIndex == index,
                      onTap: () => setState(() {
                        _activeCategoryIndex = index;
                        _selectedCategorySlug = _selectedCategorySlug == cat.slug ? null : cat.slug;
                      }),
                      imageUrl: cat.iconUrl ?? 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=600&auto=format&fit=crop',
                    ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.1);
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),

          // 4. Trending This Week (Asymmetric layout)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text('Trending Now', style: AppTextStyles.sectionHeader.copyWith(color: AppColors.mahogany, fontSize: 40)),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            sliver: eventsAsync.when(
              data: (_) {
                if (trendingEvents.isEmpty) {
                  return const SliverToBoxAdapter(child: Center(child: Text('No trending events.', style: TextStyle(color: Colors.white))));
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final event = trendingEvents[index];
                      return CompactEventCard(
                        event: event,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event)));
                        },
                      ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1);
                    },
                    childCount: trendingEvents.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
              error: (e,s) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),
          ),

          // 7. Bottom padding for floating nav
          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    );
  }
}
