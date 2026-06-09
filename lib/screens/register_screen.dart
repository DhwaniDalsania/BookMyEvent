// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/buttons/primary_button.dart';
import 'package:dio/dio.dart';
import '../providers/auth_provider.dart';
import 'main_layout.dart';
import '../widgets/images/cached_hero_image.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final phone = _phoneController.text.trim();

    if (first.isEmpty ||
        last.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields except phone are required.')),
      );
      return;
    }

    try {
      await ref
          .read(authProvider.notifier)
          .register(first, last, email, password, phone);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, a, b) => const MainLayout(),
            transitionsBuilder: (context, animation, b, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        String message = 'Registration failed. Please try again.';
        if (error is DioException) {
          final data = error.response?.data;
          if (data is Map && data['message'] != null) {
            message = data['message'].toString();
          } else if (error.message != null) {
            message = error.message!;
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AsyncLoading;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: const CachedHeroImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1540039155732-d68f126d40ee?q=80&w=600&auto=format&fit=crop',
              fit: BoxFit.cover,
              fallbackAsset: 'assets/images/placeholder_hero.jpg',
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background.withValues(alpha: 0.95),
                    AppColors.background.withValues(alpha: 0.6),
                    AppColors.cinematicDarkOverlay.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),
          // Form Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Text(
                      'Create Account',
                      style: AppTextStyles.heroTitle.copyWith(
                        color: AppColors.mahogany,
                        fontSize: 42,
                        height: 1.1,
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
                    const SizedBox(height: 12),
                    Text(
                      'Join us to unlock premium experiences.',
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mountain),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    const SizedBox(height: 48),
                    // Glassmorphic Form Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.vanilla.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // First Name
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.mountain.withValues(alpha: 0.2)),
                              ),
                              child: TextField(
                                controller: _firstNameController,
                                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mahogany),
                                decoration: InputDecoration(
                                  hintText: 'First Name',
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain),
                                  prefixIcon: const Icon(Icons.person, color: AppColors.mahogany),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Last Name
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.mountain.withValues(alpha: 0.2)),
                              ),
                              child: TextField(
                                controller: _lastNameController,
                                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mahogany),
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain),
                                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.mahogany),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Email
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.mountain.withValues(alpha: 0.2)),
                              ),
                              child: TextField(
                                controller: _emailController,
                                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mahogany),
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain),
                                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.mahogany),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Phone (optional)
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.mountain.withValues(alpha: 0.2)),
                              ),
                              child: TextField(
                                controller: _phoneController,
                                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mahogany),
                                decoration: InputDecoration(
                                  hintText: 'Phone (optional)',
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain),
                                  prefixIcon: const Icon(Icons.phone, color: AppColors.mahogany),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Password
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.mountain.withValues(alpha: 0.2)),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mahogany),
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mountain),
                                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.mahogany),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: AppColors.mahogany,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Submit Button
                            isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : PrimaryButton(
                                    text: 'Create Account',
                                    onPressed: _submit,
                                  ),
                            const SizedBox(height: 16),
                            // Back to Login
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Already have an account? Sign In',
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.tobacco, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
