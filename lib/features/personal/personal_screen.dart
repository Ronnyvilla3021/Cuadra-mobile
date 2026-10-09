import 'package:flutter/material.dart';

import '../pro/pro_gate.dart';
import 'empleados_lista.dart';

class PersonalScreen extends StatelessWidget {
  const PersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProGate(
      titulo: 'Empleados',
      icono: Icons.badge,
      descripcion: 'Gestiona los pagos de tu personal de forma fácil y rápida.',
      funciones: [
        (Icons.payments_outlined, 'Pagos'),
        (Icons.remove_circle_outline, 'Deducciones'),
        (Icons.bar_chart, 'Reportes'),
      ],
      child: EmpleadosLista(),
    );
  }
}
