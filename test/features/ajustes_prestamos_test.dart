import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_negocio/features/ajustes/tema_provider.dart';
import 'package:mi_negocio/features/prestamos/ajustes_prestamos.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('los ajustes de préstamos se guardan y se recuperan', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final c1 = ProviderContainer(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    );
    addTearDown(c1.dispose);

    // Valores iniciales: salen de la caja, sin límite.
    expect(c1.read(ajustesPrestamosProvider).salenDeCaja, isTrue);
    expect(c1.read(ajustesPrestamosProvider).limiteCentavos, isNull);

    await c1.read(ajustesPrestamosProvider.notifier).guardar(
          salenDeCaja: false,
          limiteCentavos: 50000,
        );

    final c2 = ProviderContainer(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    );
    addTearDown(c2.dispose);
    expect(c2.read(ajustesPrestamosProvider).salenDeCaja, isFalse);
    expect(c2.read(ajustesPrestamosProvider).limiteCentavos, 50000);

    // Quitar el límite.
    await c2.read(ajustesPrestamosProvider.notifier).guardar(salenDeCaja: false);
    expect(prefs.getInt('prestamos_limite_centavos'), isNull);
  });

  test('montoPlano da texto editable', () {
    expect(montoPlano(12345), '123.45');
    expect(montoPlano(5), '0.05');
    expect(montoPlano(100), '1.00');
  });
}
