import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.sectionHeader.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.mahogany),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          _buildSettingsSection('Account', [
            _buildSettingsTile(Icons.person_outline, 'Personal Information'),
            _buildSettingsTile(Icons.payment, 'Payment Methods'),
          ]),
          const SizedBox(height: 24),
          _buildSettingsSection('Preferences', [
            _buildSettingsTile(Icons.notifications_none, 'Notifications'),
            _buildSettingsTile(Icons.language, 'Language'),
            _buildSettingsTile(Icons.dark_mode_outlined, 'Dark Mode'),
          ]),
          const SizedBox(height: 24),
          _buildSettingsSection('Support', [
            _buildSettingsTile(Icons.help_outline, 'Help Center'),
            _buildSettingsTile(Icons.privacy_tip_outlined, 'Privacy Policy'),
            _buildSettingsTile(Icons.description_outlined, 'Terms of Service'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    List<Widget> dividedItems = [];
    for (int i = 0; i < items.length; i++) {
      dividedItems.add(items[i]);
      if (i < items.length - 1) {
        dividedItems.add(const Divider(height: 1, color: AppColors.sand, indent: 56));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.metadata.copyWith(color: AppColors.mountain, letterSpacing: 1.5)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.cinematicShadow.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: dividedItems),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.mahogany),
      title: Text(title, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.w500, fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.mountain),
      onTap: () {},
    );
  }
}
