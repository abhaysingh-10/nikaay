import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'; //delete it later
import 'app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ------TESTING MODE TOGGLE ------ (delete it later)
  final prefs = await SharedPreferences.getInstance();
  final runCount = prefs.getInt('temp_testing_run_count') ?? 0;
  final nextRunCount = runCount + 1;
  await prefs.setInt('temp_testing_run_count', nextRunCount);
  if (nextRunCount % 2 == 1) {
    await prefs.setBool('onboarding_completed', false);
    await FirebaseAuth.instance.signOut();
  } else {
    await prefs.setBool('onboarding_completed', true);
  }
  // -----------

  runApp(
    const ProviderScope(
      child: NikaayApp(),
    ),
  );
}
