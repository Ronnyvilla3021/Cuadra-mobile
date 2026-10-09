import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/data/database/app_database.dart';
import 'package:mi_negocio/data/database/prestamos_queries.dart';
import 'package:mi_negocio/features/alertas/calculo_avisos.dart';

ResumenPrestamo _resumen({
  required int id,
  required String nombre,
  DateTime? vence,
  int monto = 10000,
  int pagado = 0,
}) {
  return ResumenPrestamo(
    prestamo: Prestamo(
      id: id,
      clienteId: id,
      montoCentavos: monto,
      fechaPrestamo: DateTime(2026, 1, 1),
      fechaVencimiento: vence,
      nota: null,
      salioDeCaja: false,
      movimientoId: null,
      creadoEn: DateTime(2026, 1, 1),
    ),
    cliente: Cliente(
      id: id,
      nombre: nombre,
      telefono: null,
      activo: true,
      creadoEn: DateTime(2026, 1, 1),
    ),
    pagadoCentavos: pagado,
  );
}

void main() {
  final ahora = DateTime(2026, 10, 10, 12, 0);

  test('programa un aviso el día anterior y otro el día del cobro, a las 9:00', () {
    final avisos = calcularAvisos([
      _resumen(
        id: 3,
        nombre: 'Carlos',
        vence: DateTime(2026, 10, 15),
        pagado: 3000,
      ),
    ], ahora);

    expect(avisos.length, 2);
    expect(avisos[0].id, 31);
    expect(avisos[0].cuando, DateTime(2026, 10, 14, 9));
    expect(avisos[0].cuerpo, contains('Carlos'));
    expect(avisos[0].cuerpo, contains(r'$70.00')); // lo que falta, no el total
    expect(avisos[1].id, 32);
    expect(avisos[1].cuando, DateTime(2026, 10, 15, 9));
  });

  test('omite los avisos que ya pasaron', () {
    // Vence mañana: el aviso de "mañana" era hoy a las 9:00 (ya pasó).
    final avisos = calcularAvisos([
      _resumen(id: 1, nombre: 'Ana', vence: DateTime(2026, 10, 11)),
    ], ahora);

    expect(avisos.length, 1);
    expect(avisos.single.id, 12);
    expect(avisos.single.cuando, DateTime(2026, 10, 11, 9));
  });

  test('no avisa de préstamos pagados, sin fecha o ya vencidos', () {
    final avisos = calcularAvisos([
      _resumen(id: 1, nombre: 'Pagado', vence: DateTime(2026, 10, 20), pagado: 10000),
      _resumen(id: 2, nombre: 'SinFecha'),
      _resumen(id: 3, nombre: 'Vencido', vence: DateTime(2026, 10, 1)),
    ], ahora);

    expect(avisos, isEmpty);
  });
}
