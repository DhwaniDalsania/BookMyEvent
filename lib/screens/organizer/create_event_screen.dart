import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/layout/luxury_background.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../data/repositories/organizer_repository.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/models/category_model.dart';
import '../../providers/event_provider.dart';
import '../../providers/organizer_provider.dart';
import '../../utils/error_handler.dart';
import 'dart:ui';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController(text: '999');
  final _imageUrlController = TextEditingController(
    text: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=1000&auto=format&fit=crop',
  );
  DateTime _startDate = DateTime.now().add(const Duration(days: 30));
  TimeOfDay _startTime = const TimeOfDay(hour: 19, minute: 0);
  String? _categoryId;
  String? _venueId;
  String? _organizerId;
  List<CategoryModel> _categories = [];
  List<Map<String, dynamic>> _venues = [];
  bool _isLoading = true;
  bool _isPublishing = false;

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  Future<void> _loadFormData() async {
    try {
      final repo = OrganizerRepository();
      final eventRepo = EventRepository();
      final results = await Future.wait([
        eventRepo.getCategories(),
        repo.getVenues(),
        repo.getProfile(),
      ]);
      if (mounted) {
        setState(() {
          _categories = results[0] as List<CategoryModel>;
          _venues = results[1] as List<Map<String, dynamic>>;
          _organizerId = (results[2] as Map<String, dynamic>)['id'] as String?;
          _categoryId = _categories.isNotEmpty ? _categories.first.id : null;
          _venueId = _venues.isNotEmpty ? _venues.first['id'] as String? : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        final errorMessage = ErrorHandler.getErrorMessage(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load form data: $errorMessage')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _startTime);
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _publish() async {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _categoryId == null ||
        _venueId == null ||
        _organizerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() => _isPublishing = true);
    try {
      final start = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );
      final price = double.tryParse(_priceController.text) ?? 999;

      await OrganizerRepository().createEvent(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryId: _categoryId!,
        venueId: _venueId!,
        organizerId: _organizerId!,
        startTime: start,
        endTime: start.add(const Duration(hours: 3)),
        heroImageUrl: _imageUrlController.text.trim(),
        isFeatured: false,
        ticketTiers: [
          {'name': 'General', 'price': price, 'availableQty': 500},
          {'name': 'Premium', 'price': price * 2, 'availableQty': 100},
          {'name': 'VIP', 'price': price * 3.5, 'availableQty': 30},
        ],
      );

      ref.invalidate(eventsProvider(null));
      ref.invalidate(featuredEventsProvider);
      ref.invalidate(organizerEventsProvider);
      ref.invalidate(organizerStatsProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event published successfully!'),
            backgroundColor: AppColors.mahogany,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = ErrorHandler.getErrorMessage(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to publish event: $errorMessage')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGlassTextField('Event Title', 'Enter event name', Icons.title, controller: _titleController),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTapField(
                              'Date',
                              '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                              Icons.calendar_today,
                              _pickDate,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTapField(
                              'Time',
                              _startTime.format(context),
                              Icons.access_time,
                              _pickTime,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        'Category',
                        _categoryId,
                        _categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                        (v) => setState(() => _categoryId = v),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        'Venue',
                        _venueId,
                        _venues.map((v) => DropdownMenuItem(
                          value: v['id'] as String,
                          child: Text('${v['name']} — ${v['city']}'),
                        )).toList(),
                        (v) => setState(() => _venueId = v),
                      ),
                      const SizedBox(height: 16),
                      _buildGlassTextField('Ticket Price (₹)', '999', Icons.confirmation_number,
                          controller: _priceController, keyboardType: TextInputType.number),
                      const SizedBox(height: 16),
                      _buildGlassTextField('Banner Image URL', 'https://...', Icons.image,
                          controller: _imageUrlController),
                      const SizedBox(height: 16),
                      _buildGlassTextField('Description', 'What is this event about?', Icons.description,
                          controller: _descriptionController, maxLines: 4),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: _isPublishing
                            ? const Center(child: CircularProgressIndicator())
                            : PrimaryButton(text: 'Publish Event', onPressed: _publish),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<DropdownMenuItem<String>> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.metadata.copyWith(color: AppColors.mahogany)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.vanilla.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTapField(String label, String value, IconData icon, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.metadata.copyWith(color: AppColors.mahogany)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.vanilla.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.gold, size: 20),
                const SizedBox(width: 12),
                Text(value, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mahogany)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassTextField(
    String label,
    String hint,
    IconData icon, {
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
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
                controller: controller,
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
