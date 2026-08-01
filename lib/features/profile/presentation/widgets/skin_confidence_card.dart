import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';

class SkinConfidenceCard extends StatelessWidget {
  const SkinConfidenceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF0EBE1),
          width: 1.0,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.35,
              child: Image.asset(
                'assets/chat/chat_screen.png',
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Skin Profile',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'View Details',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Last updated: May 20, 2024',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.secondaryText.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFF0EBE1),
                      width: 0.8,
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        _buildProfileItem(
                          icon: Icons.opacity_outlined,
                          iconColor: const Color(0xFF3F7D3B),
                          label: 'Skin Type',
                          value: 'Oily',
                        ),
                        const VerticalDivider(
                          width: 1,
                          color: Color(0xFFF0EBE1),
                          thickness: 0.8,
                        ),
                        _buildProfileItem(
                          icon: Icons.auto_awesome_outlined,
                          iconColor: const Color(0xFFD4AF37),
                          label: 'Concerns',
                          value: 'Acne, Pores',
                        ),
                        const VerticalDivider(
                          width: 1,
                          color: Color(0xFFF0EBE1),
                          thickness: 0.8,
                        ),
                        _buildProfileItem(
                          icon: Icons.spa_outlined,
                          iconColor: const Color(0xFF2E7D32),
                          label: 'Sensitivity',
                          value: 'Low',
                          valueColor: const Color(0xFF2E7D32),
                        ),
                        const VerticalDivider(
                          width: 1,
                          color: Color(0xFFF0EBE1),
                          thickness: 0.8,
                        ),
                        _buildProfileItem(
                          icon: Icons.favorite_border,
                          iconColor: const Color(0xFFC62828),
                          label: 'Confidence',
                          value: '92%',
                          valueColor: const Color(0xFF388E3C),
                          valueWeight: FontWeight.bold,
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
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    Color? valueColor,
    FontWeight? valueWeight,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: valueWeight ?? FontWeight.normal,
              color: valueColor ?? AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
