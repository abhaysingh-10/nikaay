import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../auth/providers/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final displayName = user?.displayName ?? 'User';
    final email = user?.email ?? '';

    // Check if the current user is the developer (for demo preview purposes)
    final showCustomAvatar = user == null || 
        user.email == 'abhay@nikaay.com' || 
        user.email?.toLowerCase().contains('abhay') == true;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      color: AppColors.primaryText,
                      size: 26,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.primaryText,
                      size: 26,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. User Details Section (Avatar + Name & Email + Badge)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Photo Stack
                  Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFF0EBE1),
                            width: 2.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: showCustomAvatar
                              ? Image.asset(
                                  'assets/profile/profile.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildDefaultIconAvatar(),
                                )
                              : _buildDefaultIconAvatar(),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),

                  // Name, Email, Pill Badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName, // Dynamically loaded name with no prefix
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (email.isNotEmpty)
                          Text(
                            email,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.eco_outlined,
                                color: AppColors.primaryGreen,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Healthy Skin Journey',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Placeholder for Step 2: Skin Confidence Score Card
              const SizedBox.shrink(),

              // Placeholder for Step 3: Quick Access Grid
              const SizedBox.shrink(),

              // Placeholder for Step 4: Settings List
              const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIconAvatar() {
    return Container(
      color: AppColors.lightGreen,
      child: const Icon(
        Icons.person_outline,
        color: AppColors.primaryGreen,
        size: 44,
      ),
    );
  }
}
