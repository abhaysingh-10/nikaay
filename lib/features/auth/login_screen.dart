import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import '../../app/routes/route_names.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import 'providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  void _onForgotPasswordPressed() {
    final emailTextController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.mainBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Reset Password',
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your email address and we will send you a link to reset your password.',
                style: AppTextStyles.subtitle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailTextController,
                keyboardType: TextInputType.emailAddress,
                style: AppTextStyles.bodyText,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: AppTextStyles.subtitle.copyWith(
                      color: AppColors.secondaryText.withOpacity(0.5)),
                  filled: true,
                  fillColor: AppColors.lightBeige,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailTextController.text.trim();
                if (email.isNotEmpty) {
                  final messenger = ScaffoldMessenger.of(context);
                  Navigator.pop(context);
                  await ref
                      .read(authControllerProvider.notifier)
                      .forgotPassword(email);
                  
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Password reset email sent. Please check your inbox.'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Send Link',
                style: AppTextStyles.buttonText.copyWith(fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  String _mapAuthError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          return 'The email or password you entered is incorrect.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        default:
          return error.message ?? 'Authentication failed. Please try again.';
      }
    }
    if (error is DioException) {
      return 'Failed to sync with the server. Please verify the backend is running.';
    }
    return error.toString();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_mapAuthError(error)),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: Stack(
        children: [
          // 1. Full-screen background image
          Positioned.fill(
            child: Image.asset(
              'assets/auth/auth_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // 3. Login form content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading Section
                      Text(
                        'Welcome Back',
                        style: AppTextStyles.heroTitle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Personalized skincare, made simple.',
                        style: AppTextStyles.subtitle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 28),

                      // Email Field Label & Input
                      Text(
                        'Email',
                        style: AppTextStyles.bodyText.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        enabled: !authState.isLoading,
                        keyboardType: TextInputType.emailAddress,
                        style: AppTextStyles.bodyText,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail_outline,
                              color: AppColors.secondaryText),
                          hintText: 'Enter your email',
                          hintStyle: AppTextStyles.subtitle.copyWith(
                              color: AppColors.secondaryText.withOpacity(0.5)),
                          filled: true,
                          fillColor: AppColors.lightBeige.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password Field Label & Input
                      Text(
                        'Password',
                        style: AppTextStyles.bodyText.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        enabled: !authState.isLoading,
                        obscureText: !_isPasswordVisible,
                        style: AppTextStyles.bodyText,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: AppColors.secondaryText),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.secondaryText,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          hintText: 'Enter your password',
                          hintStyle: AppTextStyles.subtitle.copyWith(
                              color: AppColors.secondaryText.withOpacity(0.5)),
                          filled: true,
                          fillColor: AppColors.lightBeige.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: authState.isLoading ? null : _onForgotPasswordPressed,
                          child: Text(
                            'Forgot Password?',
                            style: AppTextStyles.bodyText.copyWith(
                              color: AppColors.primaryGreen,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: authState.isLoading ? null : _onLoginPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: authState.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Login',
                                  style: AppTextStyles.buttonText,
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Social Login Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.secondaryText.withOpacity(0.2),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Or continue with',
                              style: AppTextStyles.subtitle.copyWith(
                                fontSize: 13,
                                color: AppColors.secondaryText.withOpacity(0.8),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.secondaryText.withOpacity(0.2),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Social Login Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                            logoPath: 'assets/auth/google.png',
                            onTap: authState.isLoading
                                ? () {}
                                : () {
                                    debugPrint("Google Sign-In Tapped");
                                  },
                          ),
                          const SizedBox(width: 20),
                          _buildSocialButton(
                            logoPath: 'assets/auth/apple.png',
                            onTap: authState.isLoading
                                ? () {}
                                : () {
                                    debugPrint("Apple Sign-In Tapped");
                                  },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Sign Up Link
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: AppTextStyles.subtitle.copyWith(fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: AppTextStyles.bodyText.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = authState.isLoading
                                      ? null
                                      : () {
                                          context.go(RouteNames.signup);
                                        },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required String logoPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: 80,
        decoration: BoxDecoration(
          color: AppColors.lightBeige.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryGreen.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Center(
          child: Image.asset(
            logoPath,
            height: 24,
            width: 24,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

