import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/route_names.dart';
import '../../app/theme/app_colors.dart';

class AssessmentResultScreen extends StatefulWidget {
  final Map<String, dynamic>? resultData;

  const AssessmentResultScreen({
    super.key,
    this.resultData,
  });

  @override
  State<AssessmentResultScreen> createState() => _AssessmentResultScreenState();
}

class _AssessmentResultScreenState extends State<AssessmentResultScreen> {
  bool _isLoading = true;
  String _loadingMessage = 'Analyzing skin profile...';

  @override
  void initState() {
    super.initState();
    _startAnalysisSimulation();
  }

  void _startAnalysisSimulation() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _loadingMessage = 'Matching organic extracts...';
        });
      }
    });
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        setState(() {
          _loadingMessage = 'Formulating AM/PM routines...';
        });
      }
    });
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.mainBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _loadingMessage,
                  key: ValueKey(_loadingMessage),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final data = widget.resultData;
    final skinType = data?['predicted_skin_type'] ?? 'Combination Sensitive';
    final explanation = data?['explanation'] ??
        'Your skin displays traits of mild oiliness in the T-zone with sensitive areas on the cheeks. We recommend gentle hydration and soothing botanicals.';
    
    final amRoutine = data?['am_routine'] != null
        ? List<String>.from(data!['am_routine'])
        : [
            'Gentle Aloe Cleanser (Cleanse)',
            'Pure Rosewater Toner (Balance)',
            'Light Herbal Face Lotion (Moisturize & Protect)',
          ];

    final pmRoutine = data?['pm_routine'] != null
        ? List<String>.from(data!['pm_routine'])
        : [
            'Gentle Aloe Cleanser (Double Cleanse)',
            'Calming Chamomile Serum (Treat)',
            'Organic Shea Butter Cream (Deep Nourish)',
          ];

    final recIngredients = data?['recommended_ingredients'] != null
        ? List<String>.from(data!['recommended_ingredients'])
        : ['Aloe Vera', 'Rosehip Oil', 'Chamomile'];

    final avoidIngredients = data?['avoid_ingredients'] != null
        ? List<String>.from(data!['avoid_ingredients'])
        : ['Harsh Alcohol', 'Synthetic Color', 'Parabens'];

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Skin Profile',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.primaryText),
                    onPressed: () => context.go(RouteNames.home),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.secondaryText.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skinType,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      explanation,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Personalized Routine',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              _buildRoutineBlock(
                title: 'AM Routine',
                icon: Icons.wb_sunny_rounded,
                iconColor: const Color(0xFFD48B3B),
                steps: amRoutine,
              ),
              const SizedBox(height: 16),
              _buildRoutineBlock(
                title: 'PM Routine',
                icon: Icons.nightlight_round_rounded,
                iconColor: const Color(0xFF8A5DC9),
                steps: pmRoutine,
              ),
              const SizedBox(height: 24),
              Text(
                'Ingredients Guide',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.secondaryText.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle_outline, color: AppColors.primaryGreen, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'Recommended',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...recIngredients.map((item) => _buildIngredientTag(item)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.cancel_outlined, color: AppColors.error, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'Avoid',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...avoidIngredients.map((item) => _buildIngredientTag(item)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6EFE5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.secondaryText,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'AI-generated skincare guidance is for informational purposes and is not a substitute for professional medical advice.',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: AppColors.secondaryText,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => context.go(RouteNames.home),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                  child: Text(
                    'Return to Home',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoutineBlock({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> steps,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondaryText.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final val = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$idx',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      val,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildIngredientTag(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.mainBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.primaryText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
