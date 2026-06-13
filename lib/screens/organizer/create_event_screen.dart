import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../data/repositories/organizer_repository.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/models/category_model.dart';
import '../../data/models/event_model.dart';
import '../../providers/event_provider.dart';
import '../../providers/organizer_provider.dart';
import '../../utils/error_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/upload_repository.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  final EventModel? event;
  const CreateEventScreen({super.key, this.event});

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
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _priceController.text = widget.event!.startingPrice.toInt().toString();
      _imageUrlController.text = widget.event!.heroImageUrl ?? '';
      _startDate = widget.event!.startTime;
      _startTime = TimeOfDay.fromDateTime(widget.event!.startTime);
    }
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
          
          if (widget.event != null) {
            _categoryId = widget.event!.categoryId;
            if (!_categories.any((c) => c.id == _categoryId)) {
              _categoryId = _categories.isNotEmpty ? _categories.first.id : null;
            }
            _venueId = widget.event!.venueId;
            if (!_venues.any((v) => v['id'] == _venueId)) {
              _venueId = _venues.isNotEmpty ? _venues.first['id'] as String? : null;
            }
          } else {
            _categoryId = _categories.isNotEmpty ? _categories.first.id : null;
            _venueId = _venues.isNotEmpty ? _venues.first['id'] as String? : null;
          }
          
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
      final ticketTiers = [
        {'name': 'General', 'price': price, 'availableQty': 500},
        {'name': 'Premium', 'price': price * 2, 'availableQty': 100},
        {'name': 'VIP', 'price': price * 3.5, 'availableQty': 30},
      ];

      if (widget.event != null) {
        await OrganizerRepository().updateEvent(
          id: widget.event!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          categoryId: _categoryId!,
          venueId: _venueId!,
          startTime: start,
          endTime: start.add(const Duration(hours: 3)),
          heroImageUrl: _imageUrlController.text.trim(),
          ticketTiers: ticketTiers,
        );
      } else {
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
          ticketTiers: ticketTiers,
        );
      }

      ref.invalidate(eventsProvider);
      ref.invalidate(featuredEventsProvider);
      ref.invalidate(organizerEventsProvider);
      ref.invalidate(organizerStatsProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.event != null
                ? 'Event updated successfully!'
                : 'Event published successfully!'),
            backgroundColor: AppColors.mahogany,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = ErrorHandler.getErrorMessage(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.event != null
                ? 'Failed to update event: $errorMessage'
                : 'Failed to publish event: $errorMessage'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          widget.event != null ? 'Edit Event' : 'Create New Event',
          style: AppTextStyles.sectionHeader.copyWith(
            color: AppColors.mahogany,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.mahogany),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.mahogany))
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
                      [
                        ..._venues.map((v) => DropdownMenuItem(
                          value: v['id'] as String,
                          child: Text('${v['name']} — ${v['city']}'),
                        )),
                        const DropdownMenuItem(
                          value: 'ADD_CUSTOM',
                          child: Row(
                            children: [
                              Icon(Icons.add, color: AppColors.gold, size: 18),
                              SizedBox(width: 8),
                              Text('Add Custom Venue...', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                      (v) {
                        if (v == 'ADD_CUSTOM') {
                          _showAddVenueDialog(context);
                        } else {
                          setState(() => _venueId = v);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildGlassTextField('Ticket Price (₹)', '999', Icons.confirmation_number,
                        controller: _priceController, keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _buildGlassTextField(
                      'Banner Image URL',
                      'https://...',
                      Icons.image,
                      controller: _imageUrlController,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.photo_library, color: AppColors.gold),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            try {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Uploading cover image...')),
                              );
                              final uploadedUrl = await UploadRepository().uploadImage(image);
                              setState(() {
                                _imageUrlController.text = uploadedUrl;
                              });
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Cover image uploaded successfully!')),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to upload image: $e')),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildGlassTextField('Description', 'What is this event about?', Icons.description,
                        controller: _descriptionController, maxLines: 4),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: _isPublishing
                          ? const Center(child: CircularProgressIndicator(color: AppColors.mahogany))
                          : PrimaryButton(text: widget.event != null ? 'Update Event' : 'Publish Event', onPressed: _publish),
                    ),
                    const SizedBox(height: 24),
                  ],
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
        Text(label, style: AppTextStyles.metadata.copyWith(color: AppColors.mountain, letterSpacing: 1)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.sand, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: Colors.white,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mahogany),
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
        Text(label, style: AppTextStyles.metadata.copyWith(color: AppColors.mountain, letterSpacing: 1)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.sand, width: 1),
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
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.metadata.copyWith(color: AppColors.mountain, letterSpacing: 1)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.sand, width: 1),
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
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showAddVenueDialog(BuildContext context) async {
    final nameCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final stateCtrl = TextEditingController();
    final zipCtrl = TextEditingController();
    bool isSavingVenue = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.vanilla,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text('Add Custom Venue', style: AppTextStyles.sectionHeader.copyWith(color: AppColors.mahogany)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      style: const TextStyle(color: AppColors.mahogany),
                      decoration: const InputDecoration(
                        labelText: 'Venue Name',
                        labelStyle: TextStyle(color: AppColors.mountain),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: addressCtrl,
                      style: const TextStyle(color: AppColors.mahogany),
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(color: AppColors.mountain),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: cityCtrl,
                      style: const TextStyle(color: AppColors.mahogany),
                      decoration: const InputDecoration(
                        labelText: 'City',
                        labelStyle: TextStyle(color: AppColors.mountain),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: stateCtrl,
                      style: const TextStyle(color: AppColors.mahogany),
                      decoration: const InputDecoration(
                        labelText: 'State',
                        labelStyle: TextStyle(color: AppColors.mountain),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: zipCtrl,
                      style: const TextStyle(color: AppColors.mahogany),
                      decoration: const InputDecoration(
                        labelText: 'Zip Code',
                        labelStyle: TextStyle(color: AppColors.mountain),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSavingVenue ? null : () => Navigator.pop(ctx),
                  child: const Text('Cancel', style: TextStyle(color: AppColors.mountain)),
                ),
                isSavingVenue
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold),
                        ),
                      )
                    : TextButton(
                        onPressed: () async {
                          if (nameCtrl.text.trim().isEmpty ||
                              addressCtrl.text.trim().isEmpty ||
                              cityCtrl.text.trim().isEmpty ||
                              stateCtrl.text.trim().isEmpty ||
                              zipCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill all fields')),
                            );
                            return;
                          }
                          setDialogState(() => isSavingVenue = true);
                          try {
                            final newVenue = await OrganizerRepository().createVenue(
                              name: nameCtrl.text.trim(),
                              address: addressCtrl.text.trim(),
                              city: cityCtrl.text.trim(),
                              state: stateCtrl.text.trim(),
                              zipCode: zipCtrl.text.trim(),
                            );
                            if (mounted) {
                              setState(() {
                                _venues.add(newVenue);
                                _venueId = newVenue['id'] as String?;
                              });
                            }
                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Venue added successfully!')),
                              );
                            }
                          } catch (e) {
                            if (ctx.mounted) {
                              setDialogState(() => isSavingVenue = false);
                              final errMsg = ErrorHandler.getErrorMessage(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to add venue: $errMsg')),
                              );
                            }
                          }
                        },
                        child: const Text('Add Venue', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
                      ),
              ],
            );
          },
        );
      },
    );
  }
}
