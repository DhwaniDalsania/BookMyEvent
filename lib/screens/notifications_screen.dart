import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Booking Confirmed!',
        'body': 'Your tickets for Neon Nights are confirmed.',
        'time': '2h ago',
        'isUnread': true,
      },
      {
        'title': 'Event Reminder',
        'body': 'Laugh Out Loud Standup starts tomorrow at 8 PM.',
        'time': '1d ago',
        'isUnread': false,
      },
      {
        'title': 'Special Offer',
        'body': 'Get 20% off on your next booking with code PROMO20.',
        'time': '2d ago',
        'isUnread': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Notifications',
          style: AppTextStyles.sectionHeader.copyWith(
            color: AppColors.mahogany,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.mountain),
                    const SizedBox(height: 16),
                    Text(
                      'All caught up!',
                      style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You don't have any notifications right now.",
                      style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mountain),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _buildNotificationItem(
                  context,
                  item['title'] as String,
                  item['body'] as String,
                  item['time'] as String,
                  item['isUnread'] as bool,
                );
              },
            ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, String title, String body, String time, bool isUnread) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnread ? AppColors.gold : AppColors.sand,
          width: isUnread ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cinematicShadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUnread ? AppColors.gold.withValues(alpha: 0.1) : AppColors.vanillaLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUnread ? Icons.notifications_active_outlined : Icons.notifications_outlined,
              color: isUnread ? AppColors.gold : AppColors.mahogany,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title, 
                        style: AppTextStyles.cardTitle.copyWith(
                          color: AppColors.mahogany, 
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      time, 
                      style: AppTextStyles.metadata.copyWith(color: AppColors.mountain),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  body, 
                  style: AppTextStyles.bodyCopy.copyWith(
                    color: isUnread ? AppColors.mahogany : AppColors.mountain,
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
