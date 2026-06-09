import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/cards/booking_card.dart';
import '../widgets/layout/luxury_background.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../providers/booking_provider.dart';
import '../data/models/booking_model.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(userBookingsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('My Bookings'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.mahogany,
          unselectedLabelColor: AppColors.mountain,
          indicatorColor: AppColors.mahogany,
          indicatorWeight: 3,
          labelStyle: AppTextStyles.button.copyWith(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: LuxuryBackground(
        child: bookingsAsync.when(
          data: (bookings) {
            final upcomingBookings = bookings.where((b) => b.status != 'COMPLETED' && b.status != 'CANCELLED').toList();
            final pastBookings = bookings.where((b) => b.status == 'COMPLETED' || b.status == 'CANCELLED').toList();
            return TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList(upcomingBookings),
                _buildBookingList(pastBookings),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error loading bookings: $e')),
        ),
      ),
    );
  }

  Widget _buildBookingList(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Text('No bookings found.', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mountain)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingCard(booking: bookings[index]);
      },
    );
  }
}

