import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/images/cached_hero_image.dart';
import '../../providers/organizer_provider.dart';
import '../../providers/auth_provider.dart';
import '../../data/models/event_model.dart';
import 'create_event_screen.dart';

class OrganizerDashboardScreen extends ConsumerWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(organizerStatsProvider);
    final user = ref.watch(authProvider).value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Organizer Dashboard',
          style: AppTextStyles.sectionHeader.copyWith(
            color: AppColors.mahogany,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.mahogany),
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.mahogany)),
        error: (e, _) => Center(child: Text('Failed to load dashboard: $e', style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mahogany))),
        data: (stats) {
          final events = stats.events;
          final eventCount = stats.eventCount;
          final bookingCount = stats.bookingCount;
          final revenue = stats.totalRevenue;
          final organizerName = stats.organizerName.isNotEmpty ? stats.organizerName : (user?.firstName ?? 'Organizer');

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back,', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain)),
                        Text(organizerName, style: AppTextStyles.heroTitle.copyWith(fontSize: 28, color: AppColors.mahogany)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    _buildMetricCard(context, 'Events', '$eventCount', Icons.event),
                    const SizedBox(width: 16),
                    _buildMetricCard(context, 'Bookings', '$bookingCount', Icons.confirmation_number),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildMetricCard(context, 'Revenue', '₹${revenue.toInt()}', Icons.account_balance_wallet, isWide: true),
                  ],
                ),
                const SizedBox(height: 40),
                Text('Your Events', style: AppTextStyles.sectionHeader.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                if (events.isEmpty)
                  Text('No events yet. Create your first event!', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain))
                else
                  ...events.take(5).map((event) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateEventScreen(event: event),
                            ),
                          );
                          ref.invalidate(organizerStatsProvider);
                        },
                        child: _buildRecentEventCard(context, event),
                      ),
                    );
                  }),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.mahogany,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEventScreen()),
          );
          ref.invalidate(organizerStatsProvider);
        },
        icon: const Icon(Icons.add, size: 24),
        label: const Text('Create Event', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, {bool isWide = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.sand, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.cinematicShadow.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.metadata.copyWith(color: AppColors.mountain, letterSpacing: 1)),
                Icon(icon, color: AppColors.gold, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: AppTextStyles.heroTitle.copyWith(fontSize: 28, color: AppColors.mahogany)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentEventCard(BuildContext context, EventModel event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.sand, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cinematicShadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
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
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany, fontSize: 18)),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('MMM d, yyyy').format(event.startTime)} • ${event.locationName}',
                  style: AppTextStyles.metadata.copyWith(color: AppColors.mountain),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'From ₹${event.startingPrice.toInt()}',
                    style: AppTextStyles.metadata.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

