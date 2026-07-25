import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../auth/providers/auth_providers.dart';

class NotificationToggleNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void toggle() {
    state = !state;
  }
}

final notificationToggleProvider =
    NotifierProvider<NotificationToggleNotifier, bool>(
        NotificationToggleNotifier.new);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsEnabled = ref.watch(notificationToggleProvider);

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryText,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferences',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFF0EBE1),
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  _buildSettingsRow(
                    icon: Icons.language_outlined,
                    label: 'Language',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'English',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color:
                                AppColors.secondaryText.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.secondaryText.withValues(alpha: 0.6),
                          size: 20,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0xFFF6F2EB),
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildSettingsRow(
                    icon: Icons.notifications_none_outlined,
                    label: 'Notification Settings',
                    trailing: Transform.scale(
                      scale: 0.85,
                      child: Switch(
                        value: notificationsEnabled,
                        onChanged: (value) {
                          ref
                              .read(notificationToggleProvider.notifier)
                              .toggle();
                        },
                        activeTrackColor: AppColors.primaryGreen,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Privacy & Security',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFF0EBE1),
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  _buildSettingsRow(
                    icon: Icons.shield_outlined,
                    label: 'Privacy Policy',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.secondaryText.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0xFFF6F2EB),
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildSettingsRow(
                    icon: Icons.description_outlined,
                    label: 'Terms & Conditions',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.secondaryText.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0xFFF6F2EB),
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildSettingsRow(
                    icon: Icons.lock_outline,
                    label: 'Data & Security',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.secondaryText.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Support',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFF0EBE1),
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  _buildSettingsRow(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.secondaryText.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0xFFF6F2EB),
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildSettingsRow(
                    icon: Icons.info_outline,
                    label: 'About Nikaay',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.secondaryText.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            InkWell(
              onTap: () {
                ref.read(authControllerProvider.notifier).logout();
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFEBEE),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.logout,
                      color: Color(0xFFC95C54),
                      size: 22,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Logout',
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFC95C54),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFFC95C54),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String label,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
