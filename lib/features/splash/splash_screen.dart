import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/route_names.dart';
import '../../core/storage/preferences_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isOnboardingCompleted = false; // ..  => onboard changes

  @override
  void initState() {
    super.initState();
    _loadOnboardingStatus(); // ..

    // 1. Initialize the Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // 2. Setup the fade-in animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // 3. Setup the scale-up animation (from 0.9 size to 1.0)
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // 4. Start the animation
    _controller.forward();

    // 5. Navigate after the animation finishes
    _navigateToNextScreen();
  }

  //..
  Future<void> _loadOnboardingStatus() async {
    final completed = await PreferencesHelper.isOnboardingCompleted();
    if (mounted) {
      setState(() {
        _isOnboardingCompleted = completed;
      });
      // Speed up animation if onboarding is completed
      if (completed) {
        _controller.duration = const Duration(milliseconds: 1000);
        _controller.forward(from: 0.0);
      }
    }
  }

  Future<void> _navigateToNextScreen() async {
    final completed = await PreferencesHelper.isOnboardingCompleted();
    final delay = completed ? const Duration(seconds: 1) : const Duration(seconds: 2);

    await Future.delayed(delay);

    if (!mounted) return;

    // Navigate to next screen based on status.
    if (_isOnboardingCompleted) {
      context.go(RouteNames.login);
    } else {
      context.go(RouteNames.onboarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // splash bg
          if (!_isOnboardingCompleted) //..
            Positioned.fill(
              child: Image.asset(
                'assets/splash/splash_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          Align(
            alignment: _isOnboardingCompleted
                ? const Alignment(0, -0.25)
                : const Alignment(0, -0.60), //..
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/splash/splash_logo.png',
                  width: MediaQuery.of(context).size.width * 0.85,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
