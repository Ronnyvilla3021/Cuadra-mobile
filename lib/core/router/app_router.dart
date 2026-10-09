import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ajustes/ajustes_screen.dart';
import '../../features/ajustes/reportes_guardados_screen.dart';
import '../../features/caja/caja_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/personal/empleado_detalle_screen.dart';
import '../../features/personal/personal_screen.dart';
import '../../features/prestamos/calendario_prestamos_screen.dart';
import '../../features/prestamos/nuevo_prestamo_screen.dart';
import '../../features/prestamos/prestamo_detalle_screen.dart';
import '../../features/prestamos/prestamos_screen.dart';
import '../../features/pro/paywall_screen.dart';
import '../../features/reportes/exportar_screen.dart';
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
              path: '/prestamos',
              builder: (context, state) => const PrestamosScreen(),
              routes: [
                GoRoute(
                  path: 'nuevo',
                  builder: (context, state) => const NuevoPrestamoScreen(),
                ),
                GoRoute(
                  path: 'calendario',
                  builder: (context, state) =>
                      const CalendarioPrestamosScreen(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) => PrestamoDetalleScreen(
                    id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
                  ),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/personal',
              builder: (context, state) => const PersonalScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) => EmpleadoDetalleScreen(
                    id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
                  ),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/ajustes',
              builder: (context, state) => const AjustesScreen(),
              routes: [
                GoRoute(
                  path: 'exportar',
                  builder: (context, state) => const ExportarScreen(),
                ),
                GoRoute(
                  path: 'reportes',
                  builder: (context, state) =>
                      const ReportesGuardadosScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
});
