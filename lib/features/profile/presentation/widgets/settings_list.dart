import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF0EBE1),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRow(
            icon: Icons.person_outline,
            label: 'Personal Information',
            onTap: () {},
          ),
          const Divider(
            height: 1,
            color: Color(0xFFF6F2EB),
            indent: 16,
            endIndent: 16,
          ),
          _buildRow(
            icon: Icons.shield_outlined,
            label: 'Privacy & Security',
            onTap: () {},
          ),
          const Divider(
            height: 1,
            color: Color(0xFFF6F2EB),
            indent: 16,
            endIndent: 16,
          ),
          _buildRow(
            icon: Icons.notifications_none_outlined,
            label: 'Notification Settings',
            onTap: () {},
          ),
          const Divider(
            height: 1,
            color: Color(0xFFF6F2EB),
            indent: 16,
            endIndent: 16,
          ),
          _buildRow(
            icon: Icons.help_outline,
            label: 'Help & Support',
            onTap: () {},
          ),
          const Divider(
            height: 1,
            color: Color(0xFFF6F2EB),
            indent: 16,
            endIndent: 16,
          ),
          _buildRow(
            icon: Icons.info_outline,
            label: 'About Nikaay',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryText.withValues(alpha: 0.7),
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryText,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.secondaryText.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
