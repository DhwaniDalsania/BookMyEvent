import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../chips/luxury_badges.dart';

import '../../data/models/event_model.dart';
import '../images/cached_hero_image.dart';
import 'package:intl/intl.dart';

// --- Favorite Button Glass Variant ---
class GlassFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  const GlassFavoriteButton({super.key, this.isFavorite = false});

  @override
  State<GlassFavoriteButton> createState() => _GlassFavoriteButtonState();
}

class _GlassFavoriteButtonState extends State<GlassFavoriteButton> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isFavorite = !_isFavorite),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.vanilla.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.cinematicShadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? AppColors.mahogany : AppColors.mountain,
          size: 22,
        ).animate(target: _isFavorite ? 1 : 0).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.2, 1.2),
            duration: 300.ms,
            curve: Curves.elasticOut),
      ),
    );
  }
}

// --- Large Hero Card ---
class HeroEventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const HeroEventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.75, // Massive scale
        margin: const EdgeInsets.only(bottom: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: AppColors.cinematicShadow.withValues(alpha: 0.5),
              blurRadius: 40,
              spreadRadius: -10,
              offset: const Offset(0, 30),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: CachedHeroImage(
                  imageUrl: event.heroImageUrl ?? 'https://images.unsplash.com/photo-1540039155732-d68f126d40ee?q=80&w=600&auto=format&fit=crop',
                  fit: BoxFit.cover,
                  fallbackAsset: 'assets/images/placeholder_hero.jpg',
                ),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.cinematicDarkOverlay.withValues(alpha: 0.95),
                        AppColors.cinematicDarkOverlay.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 32,
                left: 32,
                child: event.isTrending
                    ? const LuxuryBadge(type: BadgeType.trending)
                    : const SizedBox.shrink(),
              ),
              const Positioned(
                top: 32,
                right: 32,
                child: GlassFavoriteButton(),
              ),
              Positioned(
                bottom: 40,
                left: 32,
                right: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: AppTextStyles.heroTitle.copyWith(
                        color: Colors.white,
                        fontSize: 52,
                        height: 1.05,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'From ₹${event.startingPrice.toInt()}',
                            style: AppTextStyles.button.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.w900),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              DateFormat('MMM d').format(event.startTime).toUpperCase(),
                              style: AppTextStyles.metadata.copyWith(color: AppColors.vanilla, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.locationName,
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureEventCard extends StatefulWidget {
  final EventModel event;
  final VoidCallback onTap;
  final bool isCompactHeight;

  const FeatureEventCard({super.key, required this.event, required this.onTap, this.isCompactHeight = false});

  @override
  State<FeatureEventCard> createState() => _FeatureEventCardState();
}

class _FeatureEventCardState extends State<FeatureEventCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: SizedBox(
        width: widget.isCompactHeight ? 280 : 340,
        height: widget.isCompactHeight ? 380 : 480,
        child: Stack(
          children: [
            // Image Background
            Positioned(
              top: 0, left: 0, right: 0, bottom: 40,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cinematicShadow.withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.network(
                    widget.event.heroImageUrl ?? 'https://images.unsplash.com/photo-1540039155732-d68f126d40ee?q=80&w=600&auto=format&fit=crop',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) { if (loadingProgress == null) return child; return Container(color: Colors.grey[900], child: const Center(child: CircularProgressIndicator(color: Colors.white24, strokeWidth: 2))); }, errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/placeholder_hero.jpg', fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            // Floating Asymmetric Text Block
            Positioned(
              bottom: 0,
              left: 20,
              right: widget.isCompactHeight ? 20 : 40, // Asymmetric right margin
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.vanilla.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cinematicShadow.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.title,
                      style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany, fontSize: 22),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM d').format(widget.event.startTime),
                          style: AppTextStyles.metadata.copyWith(color: AppColors.tobacco, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${widget.event.startingPrice.toInt()}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: AppColors.mahogany,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: const GlassFavoriteButton(),
            ),
          ],
        ),
      ).animate(target: _isHovered ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(0.96, 0.96), duration: 200.ms),
    );
  }
}

// --- Compact List Card ---
class CompactEventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const CompactEventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.cinematicShadow.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, 15),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
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
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMM d').format(event.startTime).toUpperCase(),
                      style: AppTextStyles.metadata.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.title,
                      style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany, fontSize: 20),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.locationName,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '₹${event.startingPrice.toInt()}',
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
