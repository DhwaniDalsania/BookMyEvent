// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/design_system.dart';
import '../providers/auth_provider.dart';
import '../utils/error_handler.dart';
import 'main_layout.dart';

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
  final _organizerNameController = TextEditingController();
  bool _isPasswordVisible = false;
  String _selectedRole = 'USER';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _organizerNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final phone = _phoneController.text.trim();
    final organizerName = _organizerNameController.text.trim();

    if (first.isEmpty ||
        last.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields except phone are required.')),
      );
      return;
    }

    if (_selectedRole == 'ORGANIZER' && organizerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Company / Organizer Name.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ref.read(authProvider.notifier).register(
            firstName: first,
            lastName: last,
            email: email,
            password: password,
            phone: phone.isEmpty ? null : phone,
            role: _selectedRole,
            organizerName: _selectedRole == 'ORGANIZER' ? organizerName : null,
          );

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
        final message = ErrorHandler.getErrorMessage(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _isSubmitting;
    return Scaffold(
      backgroundColor: AppColors.vanillaLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.mahogany),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.sectionHeader.copyWith(
                    color: AppColors.mahogany,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join us to unlock premium experiences',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mountain),
                ),
                const SizedBox(height: 32),
                
                // Form Card
                AppCard(
                  padding: const EdgeInsets.all(24),
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Role Selector Switch
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedRole = 'USER'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _selectedRole == 'USER'
                                      ? AppColors.mahogany
                                      : AppColors.surface.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _selectedRole == 'USER'
                                        ? AppColors.mahogany
                                        : AppColors.mountain.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Attendee',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: _selectedRole == 'USER' ? Colors.white : AppColors.mahogany,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedRole = 'ORGANIZER'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _selectedRole == 'ORGANIZER'
                                      ? AppColors.mahogany
                                      : AppColors.surface.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _selectedRole == 'ORGANIZER'
                                        ? AppColors.mahogany
                                        : AppColors.mountain.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Organizer',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: _selectedRole == 'ORGANIZER' ? Colors.white : AppColors.mahogany,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Company/Organizer Name Field (Organizer only)
                      if (_selectedRole == 'ORGANIZER') ...[
                        AppInputField(
                          controller: _organizerNameController,
                          hintText: 'Company / Organizer Name',
                          prefixIcon: const Icon(Icons.business_outlined, color: AppColors.mahogany),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Name Fields (Side by Side or stacked)
                      AppInputField(
                        controller: _firstNameController,
                        hintText: 'First Name',
                        prefixIcon: const Icon(Icons.person_outline, color: AppColors.mahogany),
                      ),
                      const SizedBox(height: 12),
                      AppInputField(
                        controller: _lastNameController,
                        hintText: 'Last Name',
                        prefixIcon: const Icon(Icons.person_outline, color: AppColors.mahogany),
                      ),
                      const SizedBox(height: 12),
                      
                      // Email
                      AppInputField(
                        controller: _emailController,
                        hintText: 'Email address',
                        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.mahogany),
                      ),
                      const SizedBox(height: 12),
                      
                      // Phone
                      AppInputField(
                        controller: _phoneController,
                        hintText: 'Phone (optional)',
                        prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.mahogany),
                      ),
                      const SizedBox(height: 12),
                      
                      // Password
                      AppInputField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: !_isPasswordVisible,
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
                      ),
                      const SizedBox(height: 24),
                      
                      // Submit Button
                      isLoading
                          ? const Center(child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(),
                            ))
                          : AppButton(
                              label: 'Create Account',
                              onPressed: _submit,
                            ),
                      const SizedBox(height: 16),
                      
                      // Link back to Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: AppTextStyles.bodyCopy.copyWith(color: AppColors.mountain),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Sign In',
                              style: AppTextStyles.bodyCopy.copyWith(
                                color: AppColors.tobacco,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
