import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/utils/fechas.dart';
import '../../core/utils/money.dart';
import '../../data/database/enums.dart';
import '../../data/database/prestamos_queries.dart';
import 'reporte_datos.dart';

const _azul = PdfColor.fromInt(0xFF1F6FEB);
const _verde = PdfColor.fromInt(0xFF16A34A);
const _rojo = PdfColor.fromInt(0xFFDC2626);
const _morado = PdfColor.fromInt(0xFF7C3AED);
const _gris = PdfColor.fromInt(0xFF6B7280);
const _fondo = PdfColor.fromInt(0xFFF1F5F9);

/// La fuente estándar del PDF solo dibuja caracteres latinos (á, ñ, etc.).
/// Lo demás (emojis, símbolos) se cambia por "?" para no romper el archivo.
String _limpio(String s) =>
    String.fromCharCodes(s.runes.map((c) => c <= 255 ? c : 63));

String _hora(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

/// Construye el PDF. No toca archivos ni la base: solo recibe los datos.
Future<Uint8List> construirReportePdf({
  required DatosReporte datos,
  required String negocio,
  required bool incluirCaja,
  required bool incluirPrestamos,
  DateTime? generado,
}) async {
  final ahora = generado ?? DateTime.now();
  final doc = pw.Document(title: 'Reporte Cuadra', author: _limpio(negocio));

  final periodo = datos.desde == datos.hasta
      ? fechaCorta(datos.desde)
      : '${fechaCorta(datos.desde)} al ${fechaCorta(datos.hasta)}';

  pw.Widget titulo(String t) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 16, bottom: 6),
        child: pw.Text(
          t,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: _azul,
          ),
        ),
      );

  pw.Widget tarjeta(String etiqueta, int centavos, PdfColor color) =>
      pw.Expanded(
        child: pw.Container(
          margin: const pw.EdgeInsets.only(right: 6),
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: _fondo,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(etiqueta, style: const pw.TextStyle(fontSize: 9, color: _gris)),
              pw.SizedBox(height: 3),
              pw.Text(
                Money.format(centavos),
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      );

  pw.Widget celda(String t, {bool negrita = false, pw.TextAlign? alinear, PdfColor? color}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        child: pw.Text(
          _limpio(t),
          textAlign: alinear,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: negrita ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: color,
          ),
        ),
      );

  pw.TableRow encabezado(List<String> cols, {Set<int> derecha = const {}}) =>
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: _fondo),
        children: [
          for (var i = 0; i < cols.length; i++)
            celda(
              cols[i],
              negrita: true,
              alinear: derecha.contains(i) ? pw.TextAlign.right : null,
            ),
        ],
      );

  const bordes = pw.TableBorder(
    horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
    bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
  );

  final widgets = <pw.Widget>[];

  // ------------------------------------------------------------ Caja
  if (incluirCaja) {
    widgets
      ..add(titulo('Caja'))
      ..add(
        pw.Row(
          children: [
            tarjeta('Ingresos', datos.ingresosCentavos, _verde),
            tarjeta('Gastos', datos.gastosCentavos, _rojo),
            tarjeta(
              'Ganancia',
              datos.gananciaCentavos,
              datos.gananciaCentavos < 0 ? _rojo : _azul,
            ),
          ],
        ),
      );

    for (final tipo in TipoMovimiento.values) {
      final cats = datos.porCategoria(tipo);
      if (cats.isEmpty) continue;
      widgets
        ..add(
          titulo(
            tipo == TipoMovimiento.ingreso
                ? 'Ingresos por categoría'
                : 'Gastos por categoría',
          ),
        )
        ..add(
          pw.Table(
            border: bordes,
            columnWidths: const {
              0: pw.FlexColumnWidth(),
              1: pw.FixedColumnWidth(90),
            },
            children: [
              for (final c in cats)
                pw.TableRow(
                  children: [
                    celda(c.key),
                    celda(Money.format(c.value), alinear: pw.TextAlign.right),
                  ],
                ),
            ],
          ),
        );
    }

    widgets.add(titulo('Movimientos'));
    if (datos.movimientos.isEmpty) {
      widgets.add(
        pw.Text(
          'No hay movimientos en este período.',
          style: const pw.TextStyle(fontSize: 10, color: _gris),
        ),
      );
    } else {
      widgets.add(
        pw.Table(
          border: bordes,
          columnWidths: const {
            0: pw.FixedColumnWidth(78),
            1: pw.FlexColumnWidth(3),
            2: pw.FlexColumnWidth(2),
            3: pw.FixedColumnWidth(80),
          },
          children: [
            encabezado(['Fecha', 'Concepto', 'Categoría', 'Monto'], derecha: {3}),
            for (final m in datos.movimientos)
              pw.TableRow(
                children: [
                  celda('${fechaCorta(m.fecha)} ${_hora(m.fecha)}'),
                  celda(m.concepto),
                  celda(m.categoria ?? '-'),
                  celda(
                    '${m.tipo == TipoMovimiento.ingreso ? '+' : '-'}${Money.format(m.montoCentavos)}',
                    alinear: pw.TextAlign.right,
                    color: m.tipo == TipoMovimiento.ingreso ? _verde : _rojo,
                  ),
                ],
              ),
          ],
        ),
      );
    }
  }

  // ------------------------------------------------------- Préstamos
  if (incluirPrestamos) {
    widgets
      ..add(titulo('Préstamos'))
      ..add(
        pw.Row(
          children: [
            tarjeta('Prestado', datos.prestadoCentavos, _azul),
            tarjeta('Cobrado', datos.cobradoCentavos, _verde),
            tarjeta('Pendiente', datos.pendienteCentavos, _rojo),
          ],
        ),
      )
      ..add(pw.SizedBox(height: 6))
      ..add(
        pw.Text(
          'Total por cobrar hoy (todos los préstamos): '
          '${Money.format(datos.porCobrarTotalCentavos)}',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
      )
      ..add(pw.SizedBox(height: 8));

    if (datos.prestamos.isEmpty) {
      widgets.add(
        pw.Text(
          'No se entregaron préstamos en este período.',
          style: const pw.TextStyle(fontSize: 10, color: _gris),
        ),
      );
    } else {
      PdfColor colorEstado(EstadoPrestamo e) => switch (e) {
            EstadoPrestamo.pagado => _verde,
            EstadoPrestamo.parcial => _morado,
            EstadoPrestamo.pendiente => _rojo,
          };
      String textoEstado(EstadoPrestamo e) => switch (e) {
            EstadoPrestamo.pagado => 'Pagado',
            EstadoPrestamo.parcial => 'Parcial',
            EstadoPrestamo.pendiente => 'Con deuda',
          };

      widgets.add(
        pw.Table(
          border: bordes,
          columnWidths: const {
            0: pw.FlexColumnWidth(2.2),
            1: pw.FixedColumnWidth(58),
            2: pw.FixedColumnWidth(58),
            3: pw.FixedColumnWidth(54),
            4: pw.FixedColumnWidth(54),
            5: pw.FixedColumnWidth(54),
            6: pw.FixedColumnWidth(54),
          },
          children: [
            encabezado(
              ['Persona', 'Entrega', 'Vence', 'Prestado', 'Pagado', 'Pendiente', 'Estado'],
              derecha: {3, 4, 5},
            ),
            for (final p in datos.prestamos)
              pw.TableRow(
                children: [
                  celda(p.cliente.nombre),
                  celda(fechaCorta(p.prestamo.fechaPrestamo)),
                  celda(
                    p.prestamo.fechaVencimiento == null
                        ? '-'
                        : fechaCorta(p.prestamo.fechaVencimiento!),
                  ),
                  celda(Money.format(p.prestamo.montoCentavos), alinear: pw.TextAlign.right),
                  celda(Money.format(p.pagadoCentavos), alinear: pw.TextAlign.right),
                  celda(Money.format(p.pendienteCentavos), alinear: pw.TextAlign.right),
                  celda(
                    textoEstado(p.estado),
                    negrita: true,
                    color: colorEstado(p.estado),
                  ),
                ],
              ),
          ],
        ),
      );
    }
  }

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(32, 32, 32, 40),
      header: (ctx) => ctx.pageNumber > 1
          ? pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Text(
                _limpio('$negocio  -  $periodo'),
                style: const pw.TextStyle(fontSize: 9, color: _gris),
              ),
            )
          : pw.SizedBox(),
      footer: (ctx) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generado con Cuadra',
            style: const pw.TextStyle(fontSize: 8, color: _gris),
          ),
          pw.Text(
            'Página ${ctx.pageNumber} de ${ctx.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: _gris),
          ),
        ],
      ),
      build: (ctx) => [
        pw.Text(
          _limpio(negocio),
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          'Reporte del $periodo',
          style: const pw.TextStyle(fontSize: 11, color: _gris),
        ),
        pw.Text(
          'Creado el ${fechaCorta(ahora)} a las ${_hora(ahora)}',
          style: const pw.TextStyle(fontSize: 9, color: _gris),
        ),
        pw.Divider(color: PdfColors.grey300),
        ...widgets,
      ],
    ),
  );

  return doc.save();
}
