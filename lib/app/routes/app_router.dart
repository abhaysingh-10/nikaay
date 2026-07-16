import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_names.dart';
import 'navigation_shell_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../core/storage/preferences_helper.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authStream = ref.watch(firebaseAuthProvider).authStateChanges();

  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: GoRouterRefreshStream(authStream),
    redirect: (context, state) async {
      final isLoggedIn = ref.read(firebaseAuthProvider).currentUser != null;
      final onboardingCompleted =
          await PreferencesHelper.isOnboardingCompleted();

      final isSplash = state.matchedLocation == RouteNames.splash;
      final isOnboarding = state.matchedLocation == RouteNames.onboarding;
      final isLogin = state.matchedLocation == RouteNames.login;
      final isSignup = state.matchedLocation == RouteNames.signup;

      if (isSplash) return null;

      if (!isLoggedIn) {
        if (!onboardingCompleted) {
          if (!isOnboarding) return RouteNames.onboarding;
        } else {
          if (!isLogin && !isSignup) return RouteNames.login;
        }
      } else {
        if (isOnboarding || isLogin || isSignup) {
          return RouteNames.home;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return NavigationShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text("Home Dashboard Placeholder")),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.chat,
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text("AI Chat Placeholder")),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.history,
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text("History Placeholder")),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text("Profile Placeholder")),
                ),
                routes: [
                  GoRoute(
                    path: RouteNames.settings,
                    builder: (context, state) => const Scaffold(
                      body: Center(child: Text("Settings Placeholder")),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
