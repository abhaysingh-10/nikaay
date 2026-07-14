import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'; //temp (need to remove afterwards)
import 'app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  //temp (need to remove afterwards)
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) => prefs.clear());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: NikaayApp(),
    ),
  );
}
