import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/route_names.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/storage/preferences_helper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _slides = [
    OnboardingData(
      imagePath: 'assets/onboarding/onboard1.png',
      title: 'Healthy Skin,\nHappy You',
      description:
          'Get personalized AI skincare recommendations designed for your unique skin.',
    ),
    OnboardingData(
      imagePath: 'assets/onboarding/onboard2.png',
      title: 'AI-Powered\nSkin Analysis',
      description:
          'Discover your unique skin needs with our advanced AI technology.',
    ),
    OnboardingData(
      imagePath: 'assets/onboarding/onboard3.png',
      title: 'Track & Improve\nYour Skin Journey',
      description:
          'Track your progress, see real results and improve your skin every day.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onNextPressed() async {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Last slide: Save onboarding state and go to login
      await PreferencesHelper.setOnboardingCompleted();
      if (mounted) {
        context.go(RouteNames.login);
      }
    }
  }

  void _onSkipPressed() {
    _pageController.animateToPage(
      _slides.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Row
            Align(
              alignment: Alignment.topRight,
              key: const ValueKey('skip_button_align'),
              child: Padding(
                padding: const EdgeInsets.only(right: 20, top: 10),
                child: _currentPage < _slides.length - 1
                    ? TextButton(
                        onPressed: _onSkipPressed,
                        child: Text(
                          'Skip',
                          style: AppTextStyles.bodyText.copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : const SizedBox(height: 48), // Keep space consistent
              ),
            ),

            // Page Slider
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heroTitle.copyWith(
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            slide.description,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.subtitle.copyWith(
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Illustration Card
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                slide.imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Footer Control Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  // Progress Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 6),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primaryGreen
                              : AppColors.secondaryText.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onNextPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _slides.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: AppTextStyles.buttonText,
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String imagePath;
  final String title;
  final String description;

  OnboardingData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
