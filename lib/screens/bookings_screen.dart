import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../providers/booking_provider.dart';
import '../data/models/booking_model.dart';
import 'dart:ui';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  bool _isUpcoming = true;

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(userBookingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withValues(alpha: 0.9),
        elevation: 0,
        title: Text('My Tickets', style: AppTextStyles.sectionHeader.copyWith(color: AppColors.mahogany, fontSize: 32)),
        centerTitle: false,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Premium Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cinematicShadow.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isUpcoming = true),
                      child: AnimatedContainer(
                        duration: 300.ms,
                        decoration: BoxDecoration(
                          color: _isUpcoming ? AppColors.mahogany : Colors.transparent,
                          borderRadius: BorderRadius.circular(21),
                        ),
                        child: Center(
                          child: Text(
                            'Upcoming',
                            style: AppTextStyles.button.copyWith(
                              color: _isUpcoming ? AppColors.gold : AppColors.mountain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isUpcoming = false),
                      child: AnimatedContainer(
                        duration: 300.ms,
                        decoration: BoxDecoration(
                          color: !_isUpcoming ? AppColors.mahogany : Colors.transparent,
                          borderRadius: BorderRadius.circular(21),
                        ),
                        child: Center(
                          child: Text(
                            'Past',
                            style: AppTextStyles.button.copyWith(
                              color: !_isUpcoming ? AppColors.gold : AppColors.mountain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Wallet Pass List
          Expanded(
            child: bookingsAsync.when(
              data: (allBookings) {
                final bookings = allBookings.where((b) {
                  if (_isUpcoming) {
                    return b.status != 'COMPLETED' && b.status != 'CANCELLED';
                  } else {
                    return b.status == 'COMPLETED' || b.status == 'CANCELLED';
                  }
                }).toList();

                if (bookings.isEmpty) {
                  return Center(
                    child: Text('No bookings found.', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mountain)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120), // Bottom padding for nav
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: _buildWalletPass(booking).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error loading tickets: $e', style: const TextStyle(color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletPass(BookingModel booking) {
    final event = booking.event;
    if (event == null) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.cinematicShadow.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          // Top section - Image and Title
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              image: DecorationImage(
                image: NetworkImage(event.heroImageUrl ?? 'https://images.unsplash.com/photo-1540039155732-d68f126d40ee?q=80&w=600&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.cinematicDarkOverlay.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event.categoryName.toUpperCase(),
                          style: AppTextStyles.metadata.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (booking.status == 'CONFIRMED' || booking.status == 'COMPLETED')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            'CONFIRMED',
                            style: AppTextStyles.metadata.copyWith(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    style: AppTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 22),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          
          // Ticket Details Divider with semicircles (Wallet Pass effect)
          Stack(
            alignment: Alignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  height: 32,
                  child: Center(
                    child: DashedDivider(color: AppColors.mountain),
                  ),
                ),
              ),
              Positioned(
                left: -16,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: -16,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          // Bottom section - Info and Barcode
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('DATE', DateFormat('MMM d, yyyy').format(event.startTime)),
                      const SizedBox(height: 16),
                      _buildInfoRow('TIME', DateFormat('h:mm a').format(event.startTime)),
                      const SizedBox(height: 16),
                      _buildInfoRow('VENUE', event.locationName),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('TICKET', style: AppTextStyles.metadata.copyWith(color: AppColors.mountain)),
                      const SizedBox(height: 4),
                      Text('${booking.ticketCount}x General', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      // Mock Barcode
                      Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.mountain.withValues(alpha: 0.3)),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              15, 
                              (index) => Container(
                                width: index % 3 == 0 ? 3 : (index % 2 == 0 ? 1.5 : 4),
                                height: 35,
                                color: AppColors.mahogany.withValues(alpha: 0.8),
                                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                              ),
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
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.metadata.copyWith(color: AppColors.mountain)),
        const SizedBox(height: 4),
        Text(
          value, 
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// Simple Dashed Divider for the ticket look
class DashedDivider extends StatelessWidget {
  final Color color;
  const DashedDivider({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.hasBoundedWidth ? constraints.maxWidth : 300.0;
        const dashWidth = 5.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
