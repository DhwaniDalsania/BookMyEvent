import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/design_system.dart';
import '../../widgets/buttons/primary_button.dart';

class EditEventScreen extends ConsumerStatefulWidget {
  final dynamic event;
  const EditEventScreen({super.key, this.event});

  @override
  ConsumerState<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends ConsumerState<EditEventScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? 'Event Name');
    _descriptionController = TextEditingController(text: widget.event?.description ?? 'Event Description');
    _locationController = TextEditingController(text: widget.event?.locationName ?? 'Location');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit Event', style: AppTextStyles.sectionHeader.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.mahogany),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          Text('Event Details', style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          AppCard(
            backgroundColor: Colors.white,
            child: Column(
              children: [
                _buildField('Event Title', _titleController),
                const SizedBox(height: 16),
                _buildField('Description', _descriptionController),
                const SizedBox(height: 16),
                _buildField('Location', _locationController),
              ],
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'Save Changes',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Changes saved successfully')),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.metadata.copyWith(color: AppColors.mountain, letterSpacing: 1)),
        const SizedBox(height: 8),
        AppInputField(
          controller: controller,
          hintText: 'Enter $label',
        ),
      ],
    );
  }
}
