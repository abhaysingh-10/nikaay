import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

class AuthController extends AsyncNotifier<void> {
  late final FirebaseAuth _auth;

  @override
  FutureOr<void> build() {
    _auth = ref.read(firebaseAuthProvider);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // 1. Firebase Sign In
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Sync profile with Django backend
      if (userCredential.user != null) {
        try {
          await _syncProfileWithBackend();
        } catch (e) {
          // Force sign out from Firebase if sync fails
          await _auth.signOut();
          rethrow;
        }
      }
    });
  }

  Future<void> signup(String email, String password, String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // 1. Firebase Sign Up
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        try {
          // 2 & 3. Run Firebase name update and Django sync in parallel
          await Future.wait([
            user.updateDisplayName(name).then((_) => user.reload()),
            _syncProfileWithBackend(fullName: name),
          ]);
        } catch (e) {
          // Force sign out from Firebase if sync/setup fails
          await _auth.signOut();
          rethrow;
        }
      }
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _auth.signOut();
    });
  }

  Future<void> forgotPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _auth.sendPasswordResetEmail(email: email);
    });
  }

  Future<void> _syncProfileWithBackend({String? fullName}) async {
    final dio = ref.read(apiClientProvider);
    // Call Django profile sync endpoint
    await dio.post(
      'auth/sync/',
      data: {
        if (fullName != null) 'full_name': fullName,
      },
    );
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(() {
  return AuthController();
});
