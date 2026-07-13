import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'; //temp (need to remove afterwards)

import 'app/app.dart';

void main() {
  //temp (need to remove afterwards)
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) => prefs.clear());
  runApp(
    const ProviderScope(
      child: NikaayApp(),
    ),
  );
}
