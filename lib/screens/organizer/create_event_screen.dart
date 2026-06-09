import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/layout/luxury_background.dart';
import '../../widgets/buttons/primary_button.dart';
import 'dart:ui';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Create New Event'),
        centerTitle: true,
      ),
      body: LuxuryBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Upload Area
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.vanilla.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.cinematicShadow.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: const Icon(Icons.add_photo_alternate, size: 32, color: AppColors.mahogany),
                          ),
                          const SizedBox(height: 16),
                          Text('Upload Event Image', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Form Fields
                _buildGlassTextField('Event Title', 'Enter event name', Icons.title),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildGlassTextField('Date', 'DD/MM/YYYY', Icons.calendar_today)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildGlassTextField('Time', 'HH:MM', Icons.access_time)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildGlassTextField('Venue', 'Event location', Icons.location_on),
                const SizedBox(height: 16),
                _buildGlassTextField('Ticket Price (₹)', '0.00', Icons.confirmation_number, keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildGlassTextField('Description', 'What is this event about?', Icons.description, maxLines: 4),
                
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: PrimaryButton(
                    text: 'Publish Event',
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Event published successfully!'),
                          backgroundColor: AppColors.mahogany,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField(String label, String hint, IconData icon, {int maxLines = 1, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.metadata.copyWith(color: AppColors.mahogany)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.vanilla.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: TextField(
                maxLines: maxLines,
                keyboardType: keyboardType,
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mahogany),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: AppTextStyles.bodyCopy.copyWith(color: AppColors.mountain.withValues(alpha: 0.5)),
                  prefixIcon: maxLines == 1 ? Icon(icon, color: AppColors.gold, size: 20) : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

