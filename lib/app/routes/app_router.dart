import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nikaay/features/splash/splash_screen.dart';
import 'route_names.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text("Onboarding Screen Placeholder")),
        ),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text("Login Screen Placeholder")),
        ),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text("Signup Screen Placeholder")),
        ),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text("Home Dashboard Placeholder")),
        ),
      ),
    ],
  );
}
