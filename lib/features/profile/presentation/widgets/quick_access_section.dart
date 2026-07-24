import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: GoogleFonts.inter(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildCard(
              context: context,
              icon: Icons.favorite_border,
              iconColor: const Color(0xFF3F7D3B),
              label: 'Saved',
              onTap: () {},
            ),
            const SizedBox(width: 12),
            _buildCard(
              context: context,
              icon: Icons.access_time_outlined,
              iconColor: const Color(0xFFE65100),
              label: 'History',
              onTap: () {},
            ),
            const SizedBox(width: 12),
            _buildCard(
              context: context,
              icon: Icons.assignment_outlined,
              iconColor: const Color(0xFF6A1B9A),
              label: 'Reports',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFF0EBE1),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.015),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 26,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
