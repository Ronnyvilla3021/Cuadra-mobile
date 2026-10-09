import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/carpeta_reportes.dart';
import '../../core/utils/fechas.dart';
import '../../data/providers.dart';
import '../ads/rewarded_export.dart';
import '../ajustes/reportes_guardados_screen.dart';
import '../pro/pro_providers.dart';
import 'compartir_pdf.dart';
import 'descargar_pdf.dart';
import 'periodo_reporte.dart';
import 'reporte_datos.dart';
import 'reporte_pdf.dart';

/// Elige período y contenido, y genera el PDF.
/// Gratis: requiere ver un video con recompensa. PRO: directo.
class ExportarScreen extends ConsumerStatefulWidget {
  const ExportarScreen({super.key});

  @override
  ConsumerState<ExportarScreen> createState() => _ExportarScreenState();
}

class _ExportarScreenState extends ConsumerState<ExportarScreen> {
  PeriodoReporte _periodo = PeriodoReporte.mes;
  RangoFechas? _personalizado;
  bool _caja = true;
  bool _prestamos = true;
  bool _trabajando = false;

  RangoFechas get _rango =>
      rangoDePeriodo(_periodo, DateTime.now(), personalizado: _personalizado);

  Future<void> _elegir(PeriodoReporte p) async {
    if (p != PeriodoReporte.personalizado) {
      setState(() => _periodo = p);
      return;
    }
    final hoy = DateTime.now();
    final r = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(hoy.year + 1, 12, 31),
      initialDateRange: DateTimeRange(start: _rango.desde, end: _rango.hasta),
    );
    if (r == null || !mounted) return;
    setState(() {
      _periodo = p;
      _personalizado = RangoFechas(r.start, r.end);
    });
  }

  String _nombreArchivo(RangoFechas r, DateTime ahora) {
    String d(DateTime x) =>
        '${x.year}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}';
    String dos(int n) => n.toString().padLeft(2, '0');
    final rango = r.desde == r.hasta ? d(r.desde) : '${d(r.desde)}_a_${d(r.hasta)}';
    return 'Cuadra_$rango'
        '_${dos(ahora.hour)}${dos(ahora.minute)}${dos(ahora.second)}.pdf';
  }

  Future<void> _generar() async {
    final messenger = ScaffoldMessenger.of(context);
    if (!_caja && !_prestamos) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Marca al menos una sección.')),
      );
      return;
    }

    final puede = await desbloquearExportacion(context, ref);
    if (!puede || !mounted) return;

    setState(() => _trabajando = true);
    try {
      final rango = _rango;
      final db = ref.read(appDatabaseProvider);
      final datos = await db.cargarDatosReporte(
        desde: rango.desde,
        hasta: rango.hasta,
      );
      final negocio = ref.read(negocioProvider).value?.nombre ?? 'Mi negocio';
      final bytes = await construirReportePdf(
        datos: datos,
        negocio: negocio,
        incluirCaja: _caja,
        incluirPrestamos: _prestamos,
      );
      final carpeta = await carpetaReportes();
      final archivo = File(
        '${carpeta.path}${Platform.pathSeparator}'
        '${_nombreArchivo(rango, DateTime.now())}',
      );
      await archivo.writeAsBytes(bytes, flush: true);
      ref.invalidate(reportesGuardadosProvider);

      if (!mounted) return;
      await _mostrarListo(archivo);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo crear el reporte: $e')),
      );
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _mostrarListo(File archivo) {
    final nombre = archivo.path.split(Platform.pathSeparator).last;
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 40),
              const SizedBox(height: 8),
              Text('Reporte listo', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(nombre, style: Theme.of(ctx).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(
                ref.read(isProProvider)
                    ? 'También quedó en "Mis reportes".'
                    : 'Guárdalo o compártelo ahora. Con PRO todos tus reportes '
                        'quedan en "Mis reportes".',
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await compartirPdf(archivo);
                },
                icon: const Icon(Icons.share),
                label: const Text('Compartir / guardar'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await guardarPdfEnCelular(context, archivo);
                },
                icon: const Icon(Icons.download),
                label: const Text('Guardar en mi celular'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esPro = ref.watch(isProProvider);
    final textTheme = Theme.of(context).textTheme;
    final r = _rango;
    final texto = r.desde == r.hasta
        ? fechaCorta(r.desde)
        : '${fechaCorta(r.desde)} al ${fechaCorta(r.hasta)}';

    return Scaffold(
      appBar: AppBar(title: const Text('Exportar reporte')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Período', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final p in PeriodoReporte.values)
                ChoiceChip(
                  label: Text(p.etiqueta),
                  selected: _periodo == p,
                  onSelected: _trabajando ? null : (_) => _elegir(p),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(texto, style: textTheme.bodyMedium),
          const SizedBox(height: 24),
          Text('Qué incluir', style: textTheme.titleMedium),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _caja,
            onChanged: _trabajando ? null : (v) => setState(() => _caja = v ?? false),
            title: const Text('Caja'),
            subtitle: const Text('Ingresos, gastos, ganancia y movimientos'),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _prestamos,
            onChanged:
                _trabajando ? null : (v) => setState(() => _prestamos = v ?? false),
            title: const Text('Préstamos'),
            subtitle: const Text('Prestado, cobrado y pendiente por persona'),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _trabajando ? null : _generar,
            icon: _trabajando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.picture_as_pdf),
            label: Text(_trabajando ? 'Creando PDF...' : 'Generar PDF'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.push(esPro ? '/ajustes/reportes' : '/pro'),
            icon: Icon(esPro ? Icons.folder_open : Icons.lock_outline),
            label: Text(esPro ? 'Mis reportes' : 'Mis reportes (PRO)'),
          ),
          const SizedBox(height: 12),
          Text(
            esPro
                ? 'Con Cuadra PRO exportas sin ver anuncios.'
                : 'Para exportar gratis verás un video corto. '
                    'Con Cuadra PRO no hay anuncios.',
            style: textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
