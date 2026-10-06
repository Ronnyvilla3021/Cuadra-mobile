import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/caja/caja_screen.dart';
import '../../features/fiados/fiados_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/personal/personal_screen.dart';
import '../../features/pro/paywall_screen.dart';
import '../widgets/adaptive_scaffold.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // Arranque: decide si hace falta configurar el negocio.
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/bienvenida',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Pantalla de suscripción PRO (a pantalla completa, sobre la barra).
      GoRoute(
        path: '/pro',
        builder: (context, state) => const PaywallScreen(),
      ),

      // App principal con navegación inferior / lateral.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AdaptiveScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/inicio',
              builder: (context, state) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/caja',
              builder: (context, state) => const CajaScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/fiados',
              builder: (context, state) => const FiadosScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/personal',
              builder: (context, state) => const PersonalScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});
