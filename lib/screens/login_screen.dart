import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/buttons/primary_button.dart';
import '../providers/auth_provider.dart';
import 'main_layout.dart';
import '../widgets/images/cached_hero_image.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _isRegistering = false;
  bool _isPasswordVisible = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) return;

    try {
      if (!_isRegistering) {
        await ref.read(authProvider.notifier).login(email, password);
      } else {
        await ref.read(authProvider.notifier).register(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          email,
          password,
          _phoneController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, a, b) => const MainLayout(),
            transitionsBuilder: (context, animation, b, child) => FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        String message = 'Authentication failed. Please check credentials.';
        if (error is Exception) {
          message = error.toString().replaceFirst('Exception: ', '');
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
              imageUrl: 'https://images.unsplash.com/photo-1540039155732-d68f126d40ee?q=80&w=600&auto=format&fit=crop',
              fit: BoxFit.cover,
              fallbackAsset: 'assets/images/placeholder_hero.jpg',
            ),
          ),
          // Deep Cinematic Gradient
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
                    // Header Text
                    Text(
                      'Welcome to\nBookMyEvent',
                      style: AppTextStyles.heroTitle.copyWith(color: AppColors.mahogany, fontSize: 42, height: 1.1),
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
                    const SizedBox(height: 12),
                    Text(
                      'Sign in to discover premium experiences.',
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mountain),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    
                    const SizedBox(height: 48),
                    
                    // Glassmorphic Form Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.vanilla.withValues(alpha: 0.95), // Solid opaque fallback for performance
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Name Fields (Only if registering)
                              if (_isRegistering) ...[
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
                              ],

                              // Email Field
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

                              // Password Field
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
                              
                              // Continue Button
                              isLoading
                                  ? const Center(child: CircularProgressIndicator())
                                  : PrimaryButton(
                                      text: _isRegistering ? 'Create Account' : 'Sign In',
                                      onPressed: _submit,
                                    ),
                              
                              const SizedBox(height: 16),

                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                                  },
                                  child: Text(
                                    _isRegistering ? 'Already have an account? Sign In' : 'Need an account? Register',
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.tobacco, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),
                              
                              // Divider
                              Row(
                                children: [
                                  Expanded(child: Divider(color: AppColors.mountain.withValues(alpha: 0.3))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text('OR', style: AppTextStyles.metadata.copyWith(color: AppColors.mountain)),
                                  ),
                                  Expanded(child: Divider(color: AppColors.mountain.withValues(alpha: 0.3))),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Guest Login
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                        pageBuilder: (context, a, b) => const MainLayout(),
                                        transitionsBuilder: (context, animation, b, child) => FadeTransition(opacity: animation, child: child),
                                        transitionDuration: const Duration(milliseconds: 800),
                                      ),
                                    );
                                  },
                                  child: Text('Continue as Guest', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.tobacco, fontWeight: FontWeight.bold)),
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

