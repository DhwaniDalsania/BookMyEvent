import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../data/models/booking_model.dart';
import '../images/cached_hero_image.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final event = booking.event;
    if (event == null) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.vanilla,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.cinematicShadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          // Upper Event Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedHeroImage(
                    imageUrl: event.heroImageUrl ?? 'https://images.unsplash.com/photo-1540039155732-d68f126d40ee?q=80&w=600&auto=format&fit=crop',
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
                      Text(
                        event.title,
                        style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${DateFormat('MMM d').format(event.startTime)} • ${DateFormat('h:mm a').format(event.startTime)}',
                        style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mountain),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${booking.ticketCount} Ticket(s)',
                            style: AppTextStyles.bodyCopy.copyWith(fontWeight: FontWeight.bold, color: AppColors.tobacco),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: booking.status == 'CONFIRMED' 
                                  ? AppColors.gold.withValues(alpha: 0.2) 
                                  : AppColors.mountain.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              booking.status,
                              style: AppTextStyles.metadata.copyWith(
                                color: booking.status == 'CONFIRMED' ? AppColors.tobacco : AppColors.mountain,
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
          
          // Ticket Tear Divider
          Row(
            children: [
              Container(
                width: 16,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        (constraints.maxWidth / 12).floor(),
                        (index) => Container(width: 6, height: 2, color: AppColors.sand),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: 16,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    bottomLeft: Radius.circular(32),
                  ),
                ),
              ),
            ],
          ),
          
          // Lower Action Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.qr_code, color: AppColors.mahogany, size: 20),
                const SizedBox(width: 8),
                Text('View Digital Ticket', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

