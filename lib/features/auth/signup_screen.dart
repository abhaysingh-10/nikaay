import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/route_names.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignupPressed() {
    if (_formKey.currentState!.validate()) {
      debugPrint("Name: ${_nameController.text}");
      debugPrint("Email: ${_emailController.text}");
      debugPrint("Password: ${_passwordController.text}");
    }
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Icon(icon,
            size: 20, color: AppColors.secondaryText.withOpacity(0.6)),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 44),
      suffixIcon: suffixIcon,
      hintText: hint,
      hintStyle: AppTextStyles.subtitle.copyWith(
        fontSize: 14,
        color: AppColors.secondaryText.withOpacity(0.45),
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            BorderSide(color: AppColors.secondaryText.withOpacity(0.12)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            BorderSide(color: AppColors.secondaryText.withOpacity(0.12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.primaryGreen, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyText.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.primaryText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/auth/auth_bg.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24.0, 50.0, 24.0, 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text('Get Started', style: AppTextStyles.heroTitle),
                      const SizedBox(height: 6),
                      Text(
                        'Create an account to start your skincare journey.',
                        style: AppTextStyles.subtitle.copyWith(
                          fontSize: 14,
                          color: AppColors.secondaryText.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _fieldLabel('Full Name'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        style: AppTextStyles.bodyText.copyWith(fontSize: 14),
                        decoration: _fieldDecoration(
                          hint: 'Enter your full name',
                          icon: Icons.person_outline,
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please enter your name'
                            : null,
                      ),
                      const SizedBox(height: 18),
                      _fieldLabel('Email'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: AppTextStyles.bodyText.copyWith(fontSize: 14),
                        decoration: _fieldDecoration(
                          hint: 'Enter your email',
                          icon: Icons.mail_outline,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter your email';
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      _fieldLabel('Password'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: AppTextStyles.bodyText.copyWith(fontSize: 14),
                        decoration: _fieldDecoration(
                          hint: 'Create a password',
                          icon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 19,
                              color: AppColors.secondaryText.withOpacity(0.5),
                            ),
                            onPressed: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter a password';
                          if (value.length < 6)
                            return 'Password must be at least 6 characters long';
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      _fieldLabel('Confirm Password'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        style: AppTextStyles.bodyText.copyWith(fontSize: 14),
                        decoration: _fieldDecoration(
                          hint: 'Confirm your password',
                          icon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 19,
                              color: AppColors.secondaryText.withOpacity(0.5),
                            ),
                            onPressed: () => setState(() =>
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please confirm your password';
                          if (value != _passwordController.text)
                            return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _onSignupPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor:
                                AppColors.primaryGreen.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ).copyWith(
                            elevation: WidgetStateProperty.resolveWith(
                              (states) =>
                                  states.contains(WidgetState.pressed) ? 0 : 2,
                            ),
                          ),
                          child:
                              Text('Sign Up', style: AppTextStyles.buttonText),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                                  color: AppColors.secondaryText
                                      .withOpacity(0.15))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'Or sign up with',
                              style: AppTextStyles.subtitle.copyWith(
                                fontSize: 12,
                                color: AppColors.secondaryText.withOpacity(0.6),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                                  color: AppColors.secondaryText
                                      .withOpacity(0.15))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                              logoPath: 'assets/auth/google.png', onTap: () {}),
                          const SizedBox(width: 16),
                          _buildSocialButton(
                              logoPath: 'assets/auth/apple.png', onTap: () {}),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Center(
                        child: TextButton(
                          onPressed: () => context.go(RouteNames.login),
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: AppTextStyles.subtitle.copyWith(
                                fontSize: 13,
                                color:
                                    AppColors.secondaryText.withOpacity(0.75),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: AppTextStyles.bodyText.copyWith(
                                    color: AppColors.primaryGreen,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: InkWell(
                onTap: () => context.go(RouteNames.login),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.secondaryText.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
      {required String logoPath, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 84,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.secondaryText.withOpacity(0.12)),
        ),
        child: Center(
          child:
              Image.asset(logoPath, height: 20, width: 20, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
