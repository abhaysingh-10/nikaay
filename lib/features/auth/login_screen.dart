import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/route_names.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      // Auth logic will be connected in Task 3.
      debugPrint("Email: ${_emailController.text}");
      debugPrint("Password: ${_passwordController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        keyboardType: TextInputType.emailAddress,
                        style: AppTextStyles.bodyText,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail_outline,
                              color: AppColors.secondaryText),
                          hintText: 'Enter your email',
                          hintStyle: AppTextStyles.subtitle.copyWith(
                              color: AppColors.secondaryText.withOpacity(0.5)),
                          filled: true,
                          fillColor: AppColors.lightBeige.withOpacity(
                              0.8), // Slightly transparent to let bg show through
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
                          fillColor: AppColors.lightBeige
                              .withOpacity(0.8), // Slightly transparent
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
                          onPressed: () {
                            // Forgot password logic will be added in Task 3
                          },
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
                          onPressed: _onLoginPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
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
                            onTap: () {
                              debugPrint("Google Sign-In Tapped");
                            },
                          ),
                          const SizedBox(width: 20),
                          _buildSocialButton(
                            logoPath: 'assets/auth/apple.png',
                            onTap: () {
                              debugPrint("Apple Sign-In Tapped");
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Sign Up Link
                      Center(
                        child: TextButton(
                          onPressed: () => context.go(RouteNames.signup),
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style:
                                  AppTextStyles.subtitle.copyWith(fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: AppTextStyles.bodyText.copyWith(
                                    color: AppColors.primaryGreen,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
