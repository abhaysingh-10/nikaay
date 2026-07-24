import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/providers/auth_providers.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(authControllerProvider.notifier).logout();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
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
    );
  }
}
