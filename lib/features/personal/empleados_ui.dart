import '../../data/database/enums.dart';

extension TipoPagoUi on TipoPago {
  /// "Hora", "Día"... (para elegir cómo se le paga).
  String get etiqueta => switch (this) {
        TipoPago.hora => 'Por hora',
        TipoPago.dia => 'Por día',
        TipoPago.semana => 'Por semana',
        TipoPago.quincena => 'Por quincena',
        TipoPago.mes => 'Por mes',
      };

  /// "horas", "días"... (lo que se cuenta al pagar).
  String get unidades => switch (this) {
        TipoPago.hora => 'horas',
        TipoPago.dia => 'días',
        TipoPago.semana => 'semanas',
        TipoPago.quincena => 'quincenas',
        TipoPago.mes => 'meses',
      };

  String get tarifaPor => switch (this) {
        TipoPago.hora => 'por hora',
        TipoPago.dia => 'por día',
        TipoPago.semana => 'por semana',
        TipoPago.quincena => 'por quincena',
        TipoPago.mes => 'por mes',
      };
}

/// 8 -> "8", 7.5 -> "7.5"
String textoUnidades(double u) =>
    u == u.roundToDouble() ? u.toInt().toString() : u.toString();
