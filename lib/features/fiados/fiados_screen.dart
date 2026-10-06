import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';
import '../pro/pro_gate.dart';

class FiadosScreen extends StatelessWidget {
  const FiadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProGate(
      titulo: 'Fiados',
      icono: Icons.groups,
      descripcion: 'Controla quién te debe dinero y registra sus pagos.',
      funciones: [
        (Icons.person_outline, 'Clientes'),
        (Icons.history, 'Historial'),
        (Icons.notifications_none, 'Recordatorios'),
      ],
      // Se reemplaza por la pantalla real en el Paso 8.
      child: PlaceholderScreen(title: 'Fiados', icon: Icons.groups),
    );
  }
}
