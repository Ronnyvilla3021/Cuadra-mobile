import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/pro/pro_providers.dart';
import '../theme/app_colors.dart';
import '../utils/breakpoints.dart';

class _Destination {
  const _Destination(
    this.label,
    this.icon,
    this.selectedIcon, {
    this.pro = false,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;

  /// Si es una función PRO (muestra un candado a los usuarios gratuitos).
  final bool pro;
}

/// Contenedor principal:
/// - Celular: barra de navegación inferior (como en el mockup).
/// - Tablet: riel lateral, y extendido (con textos) en pantallas anchas.
class AdaptiveScaffold extends ConsumerWidget {
  const AdaptiveScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    _Destination('Inicio', Icons.home_outlined, Icons.home),
    _Destination(
      'Caja',
      Icons.account_balance_wallet_outlined,
      Icons.account_balance_wallet,
    ),
    _Destination('Fiados', Icons.groups_outlined, Icons.groups, pro: true),
    _Destination('Personal', Icons.badge_outlined, Icons.badge, pro: true),
  ];

  void _onSelected(int index) {
    navigationShell.goBranch(
      index,
      // Tocar la pestaña activa vuelve a su pantalla inicial.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Widget _icono(_Destination d, {required bool seleccionado, required bool bloqueado}) {
    final icono = Icon(seleccionado ? d.selectedIcon : d.icon);
    if (!d.pro || !bloqueado) return icono;
    return Badge(
      backgroundColor: AppColors.pro,
      label: const Icon(Icons.lock, size: 10, color: Colors.black87),
      child: icono,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = context.screenSize;
    final bloqueado = !ref.watch(isProProvider);

    // En tablets el contenido no se estira de lado a lado.
    final content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840),
        child: navigationShell,
      ),
    );

    if (size == ScreenSize.compact) {
      return Scaffold(
        body: content,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onSelected,
          destinations: [
            for (final d in _destinations)
              NavigationDestination(
                icon: _icono(d, seleccionado: false, bloqueado: bloqueado),
                selectedIcon: _icono(d, seleccionado: true, bloqueado: bloqueado),
                label: d.label,
              ),
          ],
        ),
      );
    }

    final extended = size == ScreenSize.expanded;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              extended: extended,
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onSelected,
              labelType: extended
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              destinations: [
                for (final d in _destinations)
                  NavigationRailDestination(
                    icon: _icono(d, seleccionado: false, bloqueado: bloqueado),
                    selectedIcon:
                        _icono(d, seleccionado: true, bloqueado: bloqueado),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
