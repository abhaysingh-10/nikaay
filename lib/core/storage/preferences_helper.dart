import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  // Read if onboarding was completed
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  // Save that onboarding is completed
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }
}
