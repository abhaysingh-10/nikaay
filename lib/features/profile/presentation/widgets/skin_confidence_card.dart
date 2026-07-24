import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';

class SkinConfidenceCard extends StatelessWidget {
  const SkinConfidenceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF0EBE1),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skin Confidence',
                  style: GoogleFonts.inter(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your overall skin confidence score',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 68,
                    height: 68,
                    child: CircularProgressIndicator(
                      value: 0.92,
                      strokeWidth: 3.5,
                      color: Color(0xFF388E3C),
                      backgroundColor: Color(0xFFE8F5E9),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '92%',
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'Good',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF388E3C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildLeafDecoration(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeafDecoration() {
    return SizedBox(
      width: 56,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Transform.translate(
            offset: const Offset(4, 6),
            child: Transform.rotate(
              angle: -0.45,
              child: Icon(
                Icons.eco,
                color: AppColors.primaryGreen.withValues(alpha: 0.30),
                size: 36,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(-6, -10),
            child: Transform.rotate(
              angle: 0.35,
              child: Icon(
                Icons.eco,
                color: AppColors.primaryGreen.withValues(alpha: 0.55),
                size: 26,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(10, -18),
            child: Transform.rotate(
              angle: -0.15,
              child: Icon(
                Icons.eco,
                color: AppColors.primaryGreen.withValues(alpha: 0.75),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
