import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/money.dart';
import '../../data/providers.dart';

/// Configuración inicial: nombre, tipo de negocio, moneda y dinero en caja.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _tipos = [
    'Tienda',
    'Restaurante',
    'Servicios',
    'Taller',
    'Otro',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _cajaCtrl = TextEditingController();
  String _tipo = _tipos.first;
  bool _guardando = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _cajaCtrl.dispose();
    super.dispose();
  }

  Future<void> _comenzar() async {
    if (!_formKey.currentState!.validate()) return;
    final texto = _cajaCtrl.text.trim();
    final centavos = texto.isEmpty ? 0 : Money.parse(texto)!;
    await _guardar(
      nombre: _nombreCtrl.text.trim(),
      tipo: _tipo,
      saldoInicialCentavos: centavos,
    );
  }

  /// "Omitir por ahora": crea un negocio con valores por defecto.
  /// Podrá editarse después en Configuración.
  Future<void> _omitir() {
    return _guardar(nombre: 'Mi negocio', tipo: null, saldoInicialCentavos: 0);
  }

  Future<void> _guardar({
    required String nombre,
    required String? tipo,
    required int saldoInicialCentavos,
  }) async {
    if (_guardando) return;
    setState(() => _guardando = true);
    try {
      await ref.read(appDatabaseProvider).crearNegocio(
            nombre: nombre,
            tipoNegocio: tipo,
            saldoInicialCentavos: saldoInicialCentavos,
          );
      if (!mounted) return;
      context.go('/inicio');
    } catch (_) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar. Inténtalo de nuevo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.storefront_rounded,
                      size: 56,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '¡Bienvenido!',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vamos a configurar tu negocio.',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      key: const Key('campo_nombre'),
                      controller: _nombreCtrl,
                      maxLength: 80,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de tu negocio',
                        hintText: 'Ej. Mi Tienda',
                        counterText: '',
                      ),
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.length < 2) return 'Escribe el nombre de tu negocio';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _tipo,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de negocio',
                      ),
                      items: [
                        for (final t in _tipos)
                          DropdownMenuItem(value: t, child: Text(t)),
                      ],
                      onChanged: (v) => setState(() => _tipo = v ?? _tipo),
                    ),
                    const SizedBox(height: 16),
                    // Por ahora solo dólares. Otras monedas, más adelante.
                    TextFormField(
                      initialValue: r'USD - Dólar ($)',
                      enabled: false,
                      decoration: const InputDecoration(labelText: 'Moneda'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('campo_caja'),
                      controller: _cajaCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _comenzar(),
                      decoration: const InputDecoration(
                        labelText: 'Dinero inicial en caja',
                        prefixText: r'$ ',
                        hintText: '0.00',
                        helperText:
                            '¿Con cuánto dinero comienzas? Déjalo vacío si empiezas en cero',
                        helperMaxLines: 2,
                      ),
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return null;
                        return Money.parse(v) == null
                            ? 'Monto no válido (ejemplo: 100 o 100.50)'
                            : null;
                      },
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: _guardando ? null : _comenzar,
                      child: _guardando
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Comenzar'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _guardando ? null : _omitir,
                      child: const Text('Omitir por ahora'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
