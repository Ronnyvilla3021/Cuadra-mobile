import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/features/alertas/servicio_alertas.dart';

void main() {
  test('instanteUtc conserva el momento exacto', () {
    final local = DateTime(2026, 10, 15, 9, 0);
    final t = instanteUtc(local);

    expect(t.millisecondsSinceEpoch, local.millisecondsSinceEpoch);
    expect(t.timeZoneOffset, Duration.zero);
  });
}
