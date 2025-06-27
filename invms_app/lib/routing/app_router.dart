import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:invms_app/features/developer_portal/screens/api_key_screen.dart';
import 'package:invms_app/features/developer_portal/screens/developer_portal.dart';
import 'package:invms_app/features/login/login_screen.dart';
import 'package:invms_app/shared/error_screen.dart';
import '../auth/auth_cubit.dart';
import '../auth/auth_state.dart';
import '../features/inventory_saas/screens/inventory_screen.dart';

class AppRouter {
  final AuthCubit _authCubit;

  AppRouter(this._authCubit);

  late final GoRouter router = GoRouter(
    // Listen to the AuthCubit for changes and re-route accordingly
    refreshListenable: GoRouterRefreshStream(_authCubit.stream),
    debugLogDiagnostics: true, // Useful for debugging routing issues
    initialLocation: '/login', // Start at the login page
    // Define all the routes for your application
    routes: [
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'developer_portal',
        path: '/developer',
        builder: (context, state) => const DeveloperPortalScreen(),
        // Add a sub-route for API keys
        routes: [
          GoRoute(
            name: 'api_keys',
            path: 'keys', // This becomes /developer/keys
            builder: (context, state) => const ApiKeyScreen(),
          ),
        ],
      ),
      GoRoute(
        name: 'inventory_saas',
        path: '/app/inventory',
        builder: (context, state) => const InventoryScreen(),
      ),
    ],

    // This function runs before every navigation action
    redirect: (BuildContext context, GoRouterState state) {
      final authState = context.read<AuthCubit>().state;

      // Get the path the user is trying to access
      final onLoginPage = state.matchedLocation == '/login';

      if (authState is AuthUnauthenticated && !onLoginPage) {
        // If the user is logged out and NOT on the login page, send them there.
        return '/login';
      }

      if (authState is AuthAuthenticated && onLoginPage) {
        // If the user is logged IN and tries to go to the login page,
        // send them to the main app screen instead.
        return '/app/inventory';
      }

      // In all other cases, let them go where they intended.
      return null;
    },

    // This is the screen that will be shown if a route is not found
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
}

// Helper class to make GoRouter listen to a BLoC stream
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
