import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/app_info.dart';
import '../ads/ad_config.dart';
import '../ajustes/tema_provider.dart';
import 'estado_pro.dart';
import 'pro_providers.dart';

class EstadoFacturacion {
  const EstadoFacturacion({
    this.producto,
    this.cargando = false,
    this.mensaje,
  });

  /// La suscripción tal como la ve Google Play (con el precio local).
  final ProductDetails? producto;
  final bool cargando;
  final String? mensaje;

  EstadoFacturacion copiar({
    ProductDetails? producto,
    bool? cargando,
    String? mensaje,
    bool borrarMensaje = false,
  }) {
    return EstadoFacturacion(
      producto: producto ?? this.producto,
      cargando: cargando ?? this.cargando,
      mensaje: borrarMensaje ? null : (mensaje ?? this.mensaje),
    );
  }
}

/// Cobro de Cuadra PRO con Google Play Billing (sin servidor propio).
///
/// Al abrir la app pregunta a Google Play si la suscripción sigue vigente.
/// Si la tienda no conoce el producto (app sin publicar, debug), no cambia nada.
class FacturacionNotifier extends Notifier<EstadoFacturacion> {
  StreamSubscription<List<PurchaseDetails>>? _sub;
  Timer? _verificacion;
  bool _vioCompraActiva = false;

  InAppPurchase get _iap => InAppPurchase.instance;

  @override
  EstadoFacturacion build() {
    ref.onDispose(() {
      _sub?.cancel();
      _verificacion?.cancel();
    });
    if (AdConfig.disponible) Future<void>.microtask(iniciar);
    return const EstadoFacturacion();
  }

  Future<void> iniciar() async {
    try {
      _sub ??= _iap.purchaseStream.listen(
        _alRecibir,
        onError: (Object e) => state = state.copiar(
          cargando: false,
          mensaje: 'No se pudo conectar con Google Play.',
        ),
      );

      if (!await _iap.isAvailable()) return; // sin Play: se respeta lo guardado

      final respuesta = await _iap.queryProductDetails({kProductoPro});
      if (respuesta.productDetails.isEmpty) return; // la tienda no lo conoce
      state = state.copiar(producto: respuesta.productDetails.first);

      await _iap.restorePurchases();
      // Si en 15 s no llegó ninguna compra activa, la suscripción terminó.
      _verificacion?.cancel();
      _verificacion = Timer(const Duration(seconds: 15), _cerrarVerificacion);
    } catch (e) {
      debugPrint('Facturación: no se pudo iniciar: $e');
    }
  }

  Future<void> _cerrarVerificacion() async {
    final prefs = ref.read(sharedPrefsProvider);
    final ms = prefs?.getInt(kClaveProVerificado);
    final sigue = decidirPro(
      compraActiva: _vioCompraActiva,
      tiendaRespondio: true,
      cacheado: ref.read(isProProvider),
      ultimaVerificacion: ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms),
      ahora: DateTime.now(),
    );
    if (!sigue && ref.read(isProProvider)) {
      await ref.read(isProProvider.notifier).fijar(false);
    }
  }

  Future<void> _alRecibir(List<PurchaseDetails> compras) async {
    for (final c in compras) {
      if (c.productID != kProductoPro) continue;
      switch (c.status) {
        case PurchaseStatus.pending:
          state = state.copiar(cargando: true, mensaje: 'Pago pendiente...');
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _vioCompraActiva = true;
          await ref.read(isProProvider.notifier).fijar(true);
          state = state.copiar(cargando: false, borrarMensaje: true);
        case PurchaseStatus.error:
          state = state.copiar(
            cargando: false,
            mensaje: c.error?.message ?? 'No se pudo completar el pago.',
          );
        case PurchaseStatus.canceled:
          state = state.copiar(cargando: false, borrarMensaje: true);
      }
      if (c.pendingCompletePurchase) {
        await _iap.completePurchase(c);
      }
    }
  }

  /// Abre la hoja de pago de Google Play.
  Future<void> comprar() async {
    final p = state.producto;
    if (p == null) {
      state = state.copiar(mensaje: 'La suscripción no está disponible todavía.');
      return;
    }
    state = state.copiar(cargando: true, borrarMensaje: true);
    try {
      final iniciada = await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: p),
      );
      if (!iniciada) state = state.copiar(cargando: false);
    } catch (e) {
      state = state.copiar(cargando: false, mensaje: 'No se pudo iniciar el pago.');
    }
  }

  /// "Restaurar compras": útil al cambiar de celular o reinstalar.
  Future<void> restaurar() async {
    state = state.copiar(cargando: true, borrarMensaje: true);
    try {
      await _iap.restorePurchases();
    } catch (_) {
      state = state.copiar(mensaje: 'No se pudo consultar Google Play.');
    }
    // Si no hay compras no llega ningún evento: se libera el botón.
    Future<void>.delayed(const Duration(seconds: 6), () {
      if (state.cargando) {
        state = state.copiar(cargando: false, mensaje: 'No encontramos suscripciones activas.');
      }
    });
  }
}

final facturacionProvider =
    NotifierProvider<FacturacionNotifier, EstadoFacturacion>(
  FacturacionNotifier.new,
);
