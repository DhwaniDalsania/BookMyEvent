import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../data/models/event_model.dart';
import '../data/models/booking_model.dart';
import '../data/models/seat_model.dart';

class BookingSuccessScreen extends StatefulWidget {
  final EventModel event;
  final List<SelectedSeat> selectedSeats;
  final BookingModel booking;

  const BookingSuccessScreen({super.key, required this.event, required this.selectedSeats, required this.booking});

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Title
                  Text(
                    "You're Going!",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.sectionHeader.copyWith(
                      fontSize: 32,
                      color: AppColors.mahogany,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your digital ticket is ready.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mountain),
                  ),
                  
                  const SizedBox(height: 48),

                  // Digital Ticket Card strictly bounded
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF584738).withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.event.title,
                              style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany, fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${DateFormat('MMM d').format(widget.event.startTime)} • ${DateFormat('h:mm a').format(widget.event.startTime)}',
                              style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mountain),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Seats', style: AppTextStyles.metadata.copyWith(color: AppColors.mountain)),
                                      Text(
                                        widget.selectedSeats.map((s) => s.label).join(', '), 
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
                                    Text('Order ID', style: AppTextStyles.metadata.copyWith(color: AppColors.mountain)),
                                    Text(widget.booking.bookingRef, style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany)),
                                  ],
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Divider(color: AppColors.sand, thickness: 1),
                            ),
                            // Mock QR Code Area
                            Container(
                              height: 150,
                              width: 150,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.sand),
                              ),
                              child: const FittedBox(
                                child: Icon(Icons.qr_code_2, color: AppColors.mahogany),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Wallet Buttons
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildWalletButton(
                            'Apple Wallet',
                            const Icon(Icons.apple, size: 16),
                            Colors.black,
                            Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildWalletButton(
                            'Google Wallet',
                            const Icon(Icons.account_balance_wallet, size: 16),
                            Colors.white,
                            Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Text('Back to Home', style: AppTextStyles.button.copyWith(color: AppColors.mahogany)),
                  ),
                ],
              ),
            ),
          ),
          
          // Confetti Blast from top center
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2, // Straight down
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              maxBlastForce: 20,
              minBlastForce: 5,
              gravity: 0.2,
              colors: const [
                AppColors.gold,
                AppColors.sand,
                Colors.white,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletButton(String label, Widget icon, Color bgColor, Color fgColor) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: bgColor == Colors.white ? const BorderSide(color: AppColors.sand, width: 1) : BorderSide.none,
        ),
        elevation: 0,
      ),
      onPressed: () {},
      icon: icon,
      label: Text(
        label, 
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

