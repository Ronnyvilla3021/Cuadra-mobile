import '../../core/utils/fechas.dart';
import '../../core/utils/money.dart';
import '../../data/database/prestamos_queries.dart';

/// Un aviso que se mostrará en el celular del dueño en una fecha y hora.
class AvisoCobro {
  const AvisoCobro({
    required this.id,
    required this.cuando,
    required this.titulo,
    required this.cuerpo,
  });

  final int id;
  final DateTime cuando;
  final String titulo;
  final String cuerpo;
}

/// Calcula los avisos de cobro: uno el día anterior y otro el día del
/// vencimiento, a la [hora] indicada (por defecto 9:00).
/// Solo para préstamos con fecha de pago y con saldo pendiente, y solo
/// avisos que todavía están en el futuro.
List<AvisoCobro> calcularAvisos(
  List<ResumenPrestamo> lista,
  DateTime ahora, {
  int hora = 9,
}) {
  final avisos = <AvisoCobro>[];

  for (final r in lista) {
    final vence = r.prestamo.fechaVencimiento;
    if (vence == null || r.estado == EstadoPrestamo.pagado) continue;

    final dia = soloDia(vence);
    final nombre = r.cliente.nombre;
    final pendiente = Money.format(r.pendienteCentavos);

    final vispera = DateTime(dia.year, dia.month, dia.day - 1, hora);
    final delDia = DateTime(dia.year, dia.month, dia.day, hora);

    if (vispera.isAfter(ahora)) {
      avisos.add(
        AvisoCobro(
          id: r.prestamo.id * 10 + 1,
          cuando: vispera,
          titulo: 'Mañana te toca cobrar',
          cuerpo: '$nombre debe pagarte $pendiente mañana.',
        ),
      );
    }
    if (delDia.isAfter(ahora)) {
      avisos.add(
        AvisoCobro(
          id: r.prestamo.id * 10 + 2,
          cuando: delDia,
          titulo: 'Hoy te toca cobrar',
          cuerpo: 'Hoy vence el pago de $nombre: $pendiente pendiente.',
        ),
      );
    }
  }
  return avisos;
}
