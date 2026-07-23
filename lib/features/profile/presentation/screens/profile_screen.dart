import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(
            fontSize: 20,
            color: AppColors.primaryText,
          ),
        ),
      ),
    );
  }
}
