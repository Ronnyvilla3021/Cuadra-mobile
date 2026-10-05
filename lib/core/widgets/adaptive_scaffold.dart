import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/breakpoints.dart';

class _Destination {
  const _Destination(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Contenedor principal:
/// - Celular: barra de navegación inferior (como en el mockup).
/// - Tablet: riel lateral, y extendido (con textos) en pantallas anchas.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    _Destination('Inicio', Icons.home_outlined, Icons.home),
    _Destination(
      'Caja',
      Icons.account_balance_wallet_outlined,
      Icons.account_balance_wallet,
    ),
    _Destination('Fiados', Icons.groups_outlined, Icons.groups),
    _Destination('Personal', Icons.badge_outlined, Icons.badge),
  ];

  void _onSelected(int index) {
    navigationShell.goBranch(
      index,
      // Tocar la pestaña activa vuelve a su pantalla inicial.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;

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
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
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
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
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
