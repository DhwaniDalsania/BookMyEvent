import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/layout/luxury_background.dart';
import 'dart:ui';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Notifications'),
        centerTitle: false,
      ),
      body: LuxuryBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildNotificationItem(context, 'Booking Confirmed!', 'Your tickets for Neon Nights are confirmed.', '2h ago', true),
            _buildNotificationItem(context, 'Event Reminder', 'Laugh Out Loud Standup starts tomorrow at 8 PM.', '1d ago', false),
            _buildNotificationItem(context, 'Special Offer', 'Get 20% off on your next booking with code PROMO20.', '2d ago', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, String title, String body, String time, bool isUnread) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isUnread ? AppColors.gold.withValues(alpha: 0.15) : AppColors.vanilla.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isUnread ? AppColors.gold.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUnread ? AppColors.gold.withValues(alpha: 0.2) : AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_active_outlined,
                    color: isUnread ? AppColors.tobacco : AppColors.mahogany,
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
                          Expanded(child: Text(title, style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany))),
                          Text(time, style: AppTextStyles.metadata.copyWith(color: AppColors.mountain)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(body, style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mountain)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

