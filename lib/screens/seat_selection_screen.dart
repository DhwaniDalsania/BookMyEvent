import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/layout/luxury_background.dart';
import 'checkout_screen.dart';
import '../widgets/buttons/glass_button.dart';
import '../data/models/event_model.dart';
import '../providers/booking_provider.dart';

class SeatSelectionScreen extends ConsumerStatefulWidget {
  final EventModel event;
  final int ticketCount;

  const SeatSelectionScreen({super.key, required this.event, this.ticketCount = 2});

  @override
  ConsumerState<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends ConsumerState<SeatSelectionScreen> {
  final List<String> _selectedSeats = [];

  void _toggleSeat(String seatId) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_selectedSeats.contains(seatId)) {
        _selectedSeats.remove(seatId);
      } else {
        if (_selectedSeats.length < widget.ticketCount) {
          _selectedSeats.add(seatId);
        } else {
          HapticFeedback.heavyImpact();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool selectionComplete = _selectedSeats.length == widget.ticketCount;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
          child: GlassButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
        ),
        title: Column(
          children: [
            Text(
              'Select Seats',
              style: AppTextStyles.heroTitle.copyWith(fontSize: 20, color: Colors.white),
            ),
            Text(
              '${widget.ticketCount} Tickets • ${widget.event.title}',
              style: AppTextStyles.metadata.copyWith(color: AppColors.sand),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: LuxuryBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Legend
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegend('Available', AppColors.seatAvailable, false),
                          const SizedBox(width: 24),
                          _buildLegend('Selected', AppColors.seatSelected, true),
                          const SizedBox(width: 24),
                          _buildLegend('Sold', AppColors.seatUnavailable, false),
                        ],
                      ),
                    ),
                  ).animate().fadeIn().slideY(begin: -0.2),

                  // Stage Glow
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.5),
                          blurRadius: 40,
                          spreadRadius: 10,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 800.ms).scaleX(),
                  const SizedBox(height: 16),
                  Text(
                    'STAGE',
                    style: AppTextStyles.metadata.copyWith(color: AppColors.gold, letterSpacing: 6),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 40),

                  // Seat Grid Wrapped in Interactive Viewer to stop overflow
                  Expanded(
                    child: InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(40),
                      minScale: 0.5,
                      maxScale: 2.5,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: 64, // 8x8 grid
                            itemBuilder: (context, index) {
                              final row = String.fromCharCode(65 + (index ~/ 8)); // A, B, C...
                              final col = (index % 8) + 1;
                              final seatId = '$row$col';
                              
                              final isBooked = index % 9 == 0 || index % 14 == 0;
                              final isSelected = _selectedSeats.contains(seatId);

                              return _SeatDot(
                                seatId: seatId,
                                isBooked: isBooked,
                                isSelected: isSelected,
                                onTap: () => _toggleSeat(seatId),
                              );
                            },
                          ),
                        ),
                      ).animate().fadeIn(delay: 500.ms),
                    ),
                  ),
                  const SizedBox(height: 150), // Padding for bottom sheet
                ],
              ),

              // Sliding Bottom Panel
              AnimatedPositioned(
                duration: 400.ms,
                curve: Curves.easeOutCubic,
                bottom: _selectedSeats.isEmpty ? -200 : 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  decoration: BoxDecoration(
                    color: AppColors.vanilla,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Seats Selected', style: AppTextStyles.metadata.copyWith(color: AppColors.mountain)),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedSeats.join(', '),
                                  style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Total', style: AppTextStyles.metadata.copyWith(color: AppColors.mountain)),
                              const SizedBox(height: 4),
                              Text(
                                '₹${(widget.event.startingPrice * _selectedSeats.length).toInt()}',
                                style: AppTextStyles.cardTitle.copyWith(color: selectionComplete ? AppColors.gold : AppColors.mahogany),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectionComplete ? AppColors.gold : AppColors.sand,
                            foregroundColor: selectionComplete ? AppColors.mahogany : AppColors.mountain,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: selectionComplete ? 10 : 0,
                            shadowColor: AppColors.gold.withValues(alpha: 0.5),
                          ),
                          onPressed: selectionComplete ? () async {
                            // First try to lock seats via backend API
                            try {
                              showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
                              await ref.read(bookingRepositoryProvider).lockSeats(widget.event.id, _selectedSeats);
                              if (!context.mounted) return;
                              Navigator.pop(context); // close dialog
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CheckoutScreen(
                                    event: widget.event,
                                    selectedSeats: _selectedSeats,
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              Navigator.pop(context); // close dialog
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to lock seats: $e')));
                            }
                          } : null,
                          child: Text(
                            selectionComplete ? 'Proceed to Checkout' : 'Select ${widget.ticketCount - _selectedSeats.length} more seat(s)',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ).animate(target: selectionComplete ? 1 : 0).scale(duration: 200.ms, curve: Curves.easeOut),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(String text, Color color, bool isGlowing) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: isGlowing
                ? [BoxShadow(color: color.withValues(alpha: 0.8), blurRadius: 10, spreadRadius: 2)]
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyles.metadata.copyWith(color: Colors.white)),
      ],
    );
  }
}

class _SeatDot extends StatelessWidget {
  final String seatId;
  final bool isBooked;
  final bool isSelected;
  final VoidCallback onTap;

  const _SeatDot({
    required this.seatId,
    required this.isBooked,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Border? border;

    if (isBooked) {
      bgColor = const Color(0xFF382E26); // Sold
      border = null;
    } else if (isSelected) {
      bgColor = const Color(0xFFC89B3C); // Selected
      border = Border.all(color: const Color(0xFF584738), width: 2);
    } else {
      bgColor = const Color(0xFFCEC1A8); // Available
      border = Border.all(color: const Color(0xFFAAA396), width: 1);
    }

    Widget dot = GestureDetector(
      onTap: isBooked ? null : onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: border,
        ),
      ),
    );

    if (isSelected) {
      dot = dot.animate(onPlay: (c) => c.repeat(reverse: true)).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.15, 1.15),
            duration: 800.ms,
          );
    } else if (isBooked) {
      dot = Opacity(opacity: 0.4, child: dot);
    }

    return dot;
  }
}

