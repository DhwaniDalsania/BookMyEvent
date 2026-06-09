import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/layout/luxury_background.dart';
import '../../widgets/images/cached_hero_image.dart';
import 'create_event_screen.dart';
import 'dart:ui';

class OrganizerDashboardScreen extends StatelessWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Organizer Dashboard'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: LuxuryBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain)),
                      Text('Eventify', style: AppTextStyles.heroTitle.copyWith(fontSize: 28, color: AppColors.mahogany)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.vanilla.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Text('This Month', style: AppTextStyles.button.copyWith(color: AppColors.mahogany)),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.mahogany),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Metrics
              Row(
                children: [
                  _buildMetricCard(context, 'Events', '12', Icons.event),
                  const SizedBox(width: 16),
                  _buildMetricCard(context, 'Bookings', '1,245', Icons.confirmation_number),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildMetricCard(context, 'Revenue', '₹12.4L', Icons.account_balance_wallet, isWide: true),
                ],
              ),
              const SizedBox(height: 40),

              // Chart Section
              Text('Booking Overview', style: AppTextStyles.sectionHeader.copyWith(color: AppColors.mahogany)),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.vanilla.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: CustomPaint(
                      painter: _MockChartPainter(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Recent Events
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Events', style: AppTextStyles.sectionHeader.copyWith(color: AppColors.mahogany)),
                  Text('See all', style: AppTextStyles.button.copyWith(color: AppColors.tobacco)),
                ],
              ),
              const SizedBox(height: 16),
              _buildRecentEventCard(context),
              const SizedBox(height: 100), // Padding for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.mahogany,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEventScreen()),
          );
        },
        icon: const Icon(Icons.add, size: 24),
        label: const Text('Create Event', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, {bool isWide = false}) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.vanilla.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppTextStyles.metadata.copyWith(color: AppColors.mountain)),
                    Icon(icon, color: AppColors.gold, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                Text(value, style: AppTextStyles.heroTitle.copyWith(fontSize: 28, color: AppColors.mahogany)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentEventCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.vanilla,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.cinematicShadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedHeroImage(
              imageUrl: 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?q=80&w=200&auto=format&fit=crop',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              fallbackAsset: 'assets/images/placeholder_music.jpg',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sunset Music Festival', style: AppTextStyles.cardTitle.copyWith(color: AppColors.mahogany)),
                const SizedBox(height: 4),
                Text('27-29 Dec 2024 • Goa', style: AppTextStyles.metadata.copyWith(color: AppColors.mountain)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('1,024 Bookings', style: AppTextStyles.metadata.copyWith(color: AppColors.tobacco, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = AppColors.tobacco
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Y-axis labels mock
    final textStyle = AppTextStyles.metadata.copyWith(color: AppColors.mountain);
    final textSpan = TextSpan(text: '1.2K', style: textStyle);
    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, const Offset(0, 0));

    final textSpan2 = TextSpan(text: '900', style: textStyle);
    final textPainter2 = TextPainter(text: textSpan2, textDirection: TextDirection.ltr);
    textPainter2.layout();
    textPainter2.paint(canvas, Offset(0, size.height * 0.25));
    
    final textSpan3 = TextSpan(text: '600', style: textStyle);
    final textPainter3 = TextPainter(text: textSpan3, textDirection: TextDirection.ltr);
    textPainter3.layout();
    textPainter3.paint(canvas, Offset(0, size.height * 0.5));

    final textSpan4 = TextSpan(text: '300', style: textStyle);
    final textPainter4 = TextPainter(text: textSpan4, textDirection: TextDirection.ltr);
    textPainter4.layout();
    textPainter4.paint(canvas, Offset(0, size.height * 0.75));

    final textSpan5 = TextSpan(text: '0', style: textStyle);
    final textPainter5 = TextPainter(text: textSpan5, textDirection: TextDirection.ltr);
    textPainter5.layout();
    textPainter5.paint(canvas, Offset(0, size.height - 20));

    // X-axis offset
    final startX = 40.0;
    
    // Points for chart
    final points = [
      Offset(startX, size.height - 20),
      Offset(startX + (size.width - startX) * 0.2, size.height * 0.7),
      Offset(startX + (size.width - startX) * 0.4, size.height * 0.5),
      Offset(startX + (size.width - startX) * 0.6, size.height * 0.8),
      Offset(startX + (size.width - startX) * 0.8, size.height * 0.3),
      Offset(size.width, size.height * 0.4),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paintLine);

    // Draw dots and glow
    final paintDotGlow = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final paintDot = Paint()
      ..color = AppColors.tobacco
      ..style = PaintingStyle.fill;
    
    for (var point in points) {
      canvas.drawCircle(point, 8, paintDotGlow);
      canvas.drawCircle(point, 4, paintDot);
      canvas.drawCircle(point, 2, Paint()..color = Colors.white);
    }

    // X-axis labels
    final dates = ['1 Nov', '8 Nov', '15 Nov', '22 Nov', '29 Nov'];
    for (int i = 0; i < dates.length; i++) {
      final span = TextSpan(text: dates[i], style: textStyle);
      final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      final x = startX + (size.width - startX) * (i / (dates.length - 1)) - (tp.width / 2);
      tp.paint(canvas, Offset(x, size.height - 10));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

