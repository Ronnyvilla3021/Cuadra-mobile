import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/caja/caja_screen.dart';
import '../../features/fiados/fiados_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/personal/personal_screen.dart';
import '../widgets/adaptive_scaffold.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/inicio',
    routes: [
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
