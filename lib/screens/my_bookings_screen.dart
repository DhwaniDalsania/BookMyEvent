import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/cards/booking_card.dart';
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(userBookingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'My Bookings',
          style: AppTextStyles.sectionHeader.copyWith(
            color: AppColors.mahogany,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.mahogany,
          unselectedLabelColor: AppColors.mountain,
          indicatorColor: AppColors.mahogany,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: AppTextStyles.button.copyWith(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: bookingsAsync.when(
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
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.mahogany)),
        error: (e, s) => Center(child: Text('Error loading bookings: $e', style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mahogany))),
      ),
    );
  }

  Widget _buildBookingList(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.confirmation_number_outlined, size: 64, color: AppColors.mountain),
              const SizedBox(height: 16),
              Text(
                'No bookings found',
                style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'When you book an event, your tickets will appear here.',
                style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mountain),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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

