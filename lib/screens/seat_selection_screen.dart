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
import '../data/models/seat_model.dart';
import '../providers/booking_provider.dart';
import '../providers/seat_provider.dart';
import '../utils/error_handler.dart';

class SeatSelectionScreen extends ConsumerStatefulWidget {
  final EventModel event;
  final int ticketCount;

  const SeatSelectionScreen({super.key, required this.event, this.ticketCount = 2});

  @override
  ConsumerState<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends ConsumerState<SeatSelectionScreen> {
  final List<SelectedSeat> _selectedSeats = [];

  void _toggleSeat(SeatModel seat) {
    if (!seat.isAvailable) return;
    if (seat.ticketTierId == null) return;

    HapticFeedback.lightImpact();
    setState(() {
      final existing = _selectedSeats.indexWhere((s) => s.id == seat.id);
      if (existing >= 0) {
        _selectedSeats.removeAt(existing);
      } else if (_selectedSeats.length < widget.ticketCount) {
        _selectedSeats.add(SelectedSeat(
          id: seat.id,
          label: seat.label,
          ticketTierId: seat.ticketTierId!,
          price: seat.price,
        ));
      } else {
        HapticFeedback.heavyImpact();
      }
    });
  }

  double get _totalPrice => _selectedSeats.fold(0.0, (sum, s) => sum + s.price);

  Color _zoneColor(String? tierName) {
    switch (tierName?.toLowerCase()) {
      case 'vip':
        return const Color(0xFFC89B3C);
      case 'premium':
        return const Color(0xFF8B7355);
      default:
        return const Color(0xFFCEC1A8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final seatMapAsync = ref.watch(seatMapProvider((eventId: widget.event.id, price: widget.event.startingPrice)));
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
        child: seatMapAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.gold)),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event_seat_outlined, color: AppColors.sand, size: 64),
                  const SizedBox(height: 16),
                  Text('Could not load seat map', style: AppTextStyles.cardTitle.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$e', style: AppTextStyles.metadata.copyWith(color: AppColors.sand), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(seatMapProvider((eventId: widget.event.id, price: widget.event.startingPrice))),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (seatMap) => _buildSeatMapContent(seatMap, selectionComplete),
        ),
      ),
    );
  }

  Widget _buildSeatMapContent(SeatMapModel seatMap, bool selectionComplete) {
    final rows = seatMap.rows;
    final cols = seatMap.cols;
    final seatGrid = <String, SeatModel>{};
    for (final seat in seatMap.seats) {
      seatGrid[seat.label] = seat;
    }

    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildLegend('Available', AppColors.seatAvailable, false),
                      const SizedBox(width: 16),
                      _buildLegend('Selected', AppColors.seatSelected, true),
                      const SizedBox(width: 16),
                      _buildLegend('Sold', AppColors.seatUnavailable, false),
                      const SizedBox(width: 16),
                      _buildLegend('Held', AppColors.mountain, false),
                    ],
                  ),
                ),
              ).animate().fadeIn().slideY(begin: -0.2),

              if (seatMap.ticketTiers.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: seatMap.ticketTiers.map((tier) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _zoneColor(tier.name).withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _zoneColor(tier.name)),
                        ),
                        child: Text(
                          '${tier.name} — ₹${tier.price.toInt()}',
                          style: AppTextStyles.metadata.copyWith(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                ),

              const SizedBox(height: 16),
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
              ),
              const SizedBox(height: 8),
              Text(
                'STAGE',
                style: AppTextStyles.metadata.copyWith(color: AppColors.gold, letterSpacing: 6),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(40),
                  minScale: 0.5,
                  maxScale: 2.5,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(rows, (rowIndex) {
                          final rowLetter = String.fromCharCode(65 + rowIndex);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Text(
                                    rowLetter,
                                    style: AppTextStyles.metadata.copyWith(color: AppColors.sand),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ...List.generate(cols, (colIndex) {
                                  final label = '$rowLetter${colIndex + 1}';
                                  final seat = seatGrid[label];
                                  if (seat == null) {
                                    return const SizedBox(width: 36, height: 36);
                                  }
                                  final isSelected = _selectedSeats.any((s) => s.id == seat.id);
                                  final isUnavailable = seat.isBooked || seat.isHeld;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: _SeatDot(
                                      seat: seat,
                                      isSelected: isSelected,
                                      isUnavailable: isUnavailable,
                                      zoneColor: _zoneColor(seat.ticketTierName),
                                      onTap: () => _toggleSeat(seat),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 150),
            ],
          ),

          AnimatedPositioned(
            duration: 400.ms,
            curve: Curves.easeOutCubic,
            bottom: _selectedSeats.isEmpty ? -220 : 0,
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
                              _selectedSeats.map((s) => s.label).join(', '),
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
                            '₹${_totalPrice.toInt()}',
                            style: AppTextStyles.cardTitle.copyWith(
                              color: selectionComplete ? AppColors.gold : AppColors.mahogany,
                            ),
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
                      onPressed: selectionComplete ? () => _proceedToCheckout() : null,
                      child: Text(
                        selectionComplete
                            ? 'Proceed to Checkout'
                            : 'Select ${widget.ticketCount - _selectedSeats.length} more seat(s)',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _proceedToCheckout() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      await ref.read(bookingRepositoryProvider).lockSeats(widget.event.id, _selectedSeats);
      if (!mounted) return;
      Navigator.pop(context);
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
      if (!mounted) return;
      Navigator.pop(context);
      final errorMessage = ErrorHandler.getErrorMessage(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to lock seats: $errorMessage')),
      );
    }
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
  final SeatModel seat;
  final bool isSelected;
  final bool isUnavailable;
  final Color zoneColor;
  final VoidCallback onTap;

  const _SeatDot({
    required this.seat,
    required this.isSelected,
    required this.isUnavailable,
    required this.zoneColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Border? border;

    if (isUnavailable) {
      bgColor = const Color(0xFF382E26);
      border = null;
    } else if (isSelected) {
      bgColor = const Color(0xFFC89B3C);
      border = Border.all(color: const Color(0xFF584738), width: 2);
    } else {
      bgColor = zoneColor;
      border = Border.all(color: const Color(0xFFAAA396), width: 1);
    }

    Widget dot = GestureDetector(
      onTap: isUnavailable ? null : onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: border,
        ),
        child: Center(
          child: Text(
            seat.seatNumber,
            style: TextStyle(
              fontSize: 10,
              color: isUnavailable ? Colors.white24 : AppColors.mahogany,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );

    if (isSelected) {
      dot = dot.animate(onPlay: (c) => c.repeat(reverse: true)).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.1, 1.1),
            duration: 800.ms,
          );
    } else if (isUnavailable) {
      dot = Opacity(opacity: 0.4, child: dot);
    }

    return dot;
  }
}
