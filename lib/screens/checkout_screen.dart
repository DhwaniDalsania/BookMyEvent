import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// font_awesome not needed for current payment methods
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/layout/luxury_background.dart';
import 'booking_success_screen.dart';
import '../data/models/event_model.dart';
import '../data/models/booking_model.dart';
import '../providers/booking_provider.dart';
import '../providers/payment_provider.dart';
import '../widgets/images/cached_hero_image.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final EventModel event;
  final List<String> selectedSeats;

  const CheckoutScreen({super.key, required this.event, required this.selectedSeats});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _selectedPaymentMethod = 'UPI';
  late Razorpay _razorpay;
  bool _isProcessing = false;
  BookingModel? _currentBooking;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (_currentBooking == null) return;
    
    // Verify Payment with Backend
    try {
      final isSuccess = await ref.read(paymentRepositoryProvider).verifyPayment(
        _currentBooking!.id,
        response.paymentId!,
        response.orderId!,
        response.signature!,
      );

      if (isSuccess && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BookingSuccessScreen(
              event: widget.event,
              selectedSeats: widget.selectedSeats,
              booking: _currentBooking!,
            ),
          ),
        );
      } else {
        _showError('Payment Verification Failed');
      }
    } catch (e) {
      _showError('Payment Verification Failed');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showError('Payment Failed: ${response.message}');
    if (mounted) setState(() => _isProcessing = false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showError('External Wallet Selected: ${response.walletName}');
    if (mounted) setState(() => _isProcessing = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  Future<void> _processPayment(double totalAmount) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      // 1. Create Booking
      _currentBooking = await ref.read(bookingRepositoryProvider).createBooking(
        widget.event.id,
        widget.selectedSeats,
      );

      // 2. We already got the razorpayOrderId from createBooking OR we can call create order API
      String orderId = _currentBooking!.razorpayOrderId ?? '';
      
      if (orderId.isEmpty) {
        orderId = await ref.read(paymentRepositoryProvider).createRazorpayOrder(_currentBooking!.id);
      }

      // 3. Open Razorpay
      var options = {
        'key': 'rzp_test_Sz9hWAHNKvhXtX',
        'amount': (totalAmount * 100).toInt(), // in paisa
        'name': 'BookMyEvent',
        'description': 'Tickets for ${widget.event.title}',
        'order_id': orderId,
        'prefill': {
          'contact': '9999999999',
          'email': 'user@example.com'
        }
      };
      _razorpay.open(options);
    } catch (e) {
      _showError('Failed to initiate payment: $e');
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketPrice = widget.event.startingPrice * widget.selectedSeats.length;
    final bookingFee = 99.0;
    final platformFee = 49.0;
    final totalAmount = ticketPrice + bookingFee + platformFee;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.mahogany),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Checkout', style: AppTextStyles.heroTitle.copyWith(fontSize: 24, color: AppColors.mahogany)),
        centerTitle: true,
      ),
      body: LuxuryBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Boarding Pass / Receipt Ticket
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mahogany.withValues(alpha: 0.1),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Upper Ticket Part
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedHeroImage(
                              imageUrl: widget.event.heroImageUrl ?? 'https://images.unsplash.com/photo-1540039155732-d68f126d40ee?q=80&w=600&auto=format&fit=crop',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              fallbackAsset: 'assets/images/placeholder_hero.jpg',
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.gold.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'PREMIUM',
                                    style: AppTextStyles.metadata.copyWith(color: AppColors.tobacco, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.event.title,
                                  style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany, fontSize: 20),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${DateFormat('MMM d').format(widget.event.startTime)} • ${DateFormat('h:mm a').format(widget.event.startTime)}',
                                  style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mountain),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tear-off Divider
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Dashed Line
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  (constraints.maxWidth / 10).floor(),
                                  (index) => Container(
                                    width: 5,
                                    height: 2,
                                  color: AppColors.sand,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Cutouts
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 16,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppColors.vanilla,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(32),
                                bottomRight: Radius.circular(32),
                              ),
                            ),
                          ),
                          Container(
                            width: 16,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppColors.vanilla,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                bottomLeft: Radius.circular(32),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Lower Receipt Part
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildReceiptRow('Seats (${widget.selectedSeats.length})', widget.selectedSeats.join(', '), isBold: true),
                        const SizedBox(height: 16),
                        _buildReceiptRow('Ticket Price', '₹${ticketPrice.toInt()}'),
                        const SizedBox(height: 12),
                        _buildReceiptRow('Booking Fee', '₹${bookingFee.toInt()}'),
                        const SizedBox(height: 12),
                        _buildReceiptRow('Taxes & Platform', '₹${platformFee.toInt()}'),
                        const SizedBox(height: 16),
                        const Divider(color: AppColors.sand, thickness: 1),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount', style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mountain)),
                            Text(
                              '₹${totalAmount.toInt()}',
                              style: AppTextStyles.heroTitle.copyWith(color: AppColors.mahogany, fontSize: 28),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1),

            const SizedBox(height: 32),

            // 2. Luxury Security Seal
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user_outlined, color: AppColors.gold, size: 20),
                const SizedBox(width: 8),
                Text(
                  '100% SECURE CHECKOUT',
                  style: AppTextStyles.metadata.copyWith(color: AppColors.mountain, letterSpacing: 2),
                ),
              ],
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 32),

            // 3. Payment Methods (Golden Buttons)
            Text(
              'Select Payment Method',
              style: AppTextStyles.sectionHeader.copyWith(color: AppColors.mahogany),
            ).animate().fadeIn(delay: 300.ms),
            
            const SizedBox(height: 24),

            _buildLuxuryPaymentOption('UPI', 'UPI / Google Pay', const Icon(Icons.account_balance_wallet, size: 24)),
            const SizedBox(height: 16),
            _buildLuxuryPaymentOption('CARD', 'Credit / Debit Card', const Icon(Icons.credit_card, size: 24)),
            const SizedBox(height: 16),
            _buildLuxuryPaymentOption('NET_BANKING', 'Net Banking', const Icon(Icons.account_balance, size: 24)),
          ],
        ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
        decoration: BoxDecoration(
          color: AppColors.vanilla,
          boxShadow: [
            BoxShadow(
              color: AppColors.mahogany.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold, // Gold CTA
              foregroundColor: AppColors.mahogany,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 10,
              shadowColor: AppColors.gold.withValues(alpha: 0.4),
            ),
            onPressed: _isProcessing ? null : () => _processPayment(totalAmount),
            child: _isProcessing 
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: AppColors.mahogany))
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pay ₹${totalAmount.toInt()}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyCopy.copyWith(
            color: isBold ? AppColors.mahogany : AppColors.mountain,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyCopy.copyWith(
            color: AppColors.mahogany,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLuxuryPaymentOption(String id, String name, Widget iconWidget) {
    final isSelected = _selectedPaymentMethod == id;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : AppColors.sand.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.gold : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))]
              : [],
        ),
        child: Row(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(
                  color: isSelected ? AppColors.mahogany : AppColors.mountain,
                ),
              ),
              child: iconWidget,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.cardTitle.copyWith(
                  color: isSelected ? AppColors.mahogany : AppColors.mountain,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.gold : AppColors.mountain.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
    );
  }
}
