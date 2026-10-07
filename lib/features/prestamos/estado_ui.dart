import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/database/prestamos_queries.dart';

const colorParcial = Color(0xFF8B5CF6); // morado

extension EstadoPrestamoUi on EstadoPrestamo {
  Color get color => switch (this) {
        EstadoPrestamo.pendiente => AppColors.expense, // rojo
        EstadoPrestamo.parcial => colorParcial, // morado
        EstadoPrestamo.pagado => AppColors.income, // verde
      };

  String get etiqueta => switch (this) {
        EstadoPrestamo.pendiente => 'Con deuda',
        EstadoPrestamo.parcial => 'Pago parcial',
        EstadoPrestamo.pagado => 'Pagado',
      };
}

class EstadoChip extends StatelessWidget {
  const EstadoChip({super.key, required this.estado});

  final EstadoPrestamo estado;

  @override
  Widget build(BuildContext context) {
    final color = estado.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado.etiqueta,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
