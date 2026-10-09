import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../data/database/prestamos_queries.dart';
import '../ads/ad_config.dart';
import '../ajustes/tema_provider.dart';
import 'calculo_avisos.dart';

/// ¿El dueño quiere recibir avisos de cobro? (por defecto, sí)
class AvisosCobroNotifier extends Notifier<bool> {
  static const _clave = 'avisos_cobro';

  @override
  bool build() => ref.watch(sharedPrefsProvider)?.getBool(_clave) ?? true;

  Future<void> establecer(bool activos) async {
    state = activos;
    await ref.read(sharedPrefsProvider)?.setBool(_clave, activos);
  }
}

final avisosCobroProvider = NotifierProvider<AvisosCobroNotifier, bool>(
  AvisosCobroNotifier.new,
);

/// Programa notificaciones locales en el celular (gratis, sin servidor ni
/// internet). Se vuelve a calcular todo cada vez que cambian los préstamos.
class ServicioAlertas {
  ServicioAlertas(this._ref);

  static const _kPreguntado = 'alertas_preguntado';

  final Ref _ref;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _listo = false;

  static const _detalles = NotificationDetails(
    android: AndroidNotificationDetails(
      'cobros',
      'Cobros de préstamos',
      channelDescription: 'Avisos de los cobros que vencen',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  Future<void> _inicializar() async {
    if (_listo) return;
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _listo = true;
  }

  /// Pide a Android permiso para mostrar notificaciones (Android 13 o más).
  Future<bool> pedirPermiso() async {
    if (!AdConfig.disponible) return false;
    try {
      await _inicializar();
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await android?.requestNotificationsPermission() ?? false;
    } catch (e) {
      debugPrint('Alertas: no se pudo pedir el permiso: $e');
      return false;
    }
  }

  /// Para no volver a preguntar cada vez que se crea un préstamo.
  bool yaPreguntado() {
    final prefs = _ref.read(sharedPrefsProvider);
    return prefs == null || (prefs.getBool(_kPreguntado) ?? false);
  }

  Future<void> marcarPreguntado() async {
    await _ref.read(sharedPrefsProvider)?.setBool(_kPreguntado, true);
  }

  /// Reprograma todos los avisos según los préstamos actuales.
  Future<void> sincronizar(
    List<ResumenPrestamo> lista, {
    required bool activos,
  }) async {
    if (!AdConfig.disponible) return;
    try {
      await _inicializar();
      await _plugin.cancelAllPendingNotifications();
      if (!activos) return;

      for (final a in calcularAvisos(lista, DateTime.now())) {
        await _plugin.zonedSchedule(
          id: a.id,
          title: a.titulo,
          body: a.cuerpo,
          scheduledDate: _instante(a.cuando),
          notificationDetails: _detalles,
          // "Inexacto": no necesita permiso de alarmas exactas; Android puede
          // retrasarlo unos minutos, algo normal para un recordatorio.
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    } catch (e) {
      debugPrint('Alertas: no se pudieron programar los avisos: $e');
    }
  }

  /// Solo para pruebas en modo debug: muestra un aviso ahora mismo.
  Future<void> probarAhora() async {
    if (!AdConfig.disponible) return;
    try {
      await _inicializar();
      await pedirPermiso();
      await _plugin.show(
        id: 9999,
        title: 'Cuadra',
        body: 'Así se verán tus avisos de cobro.',
        notificationDetails: _detalles,
      );
    } catch (e) {
      debugPrint('Alertas: fallo el aviso de prueba: $e');
    }
  }

  /// Solo para pruebas en modo debug: programa un aviso para dentro de 1 minuto.
  Future<void> probarEnUnMinuto() async {
    if (!AdConfig.disponible) return;
    try {
      await _inicializar();
      await pedirPermiso();
      await _plugin.zonedSchedule(
        id: 9998,
        title: 'Cuadra',
        body: 'Aviso programado de prueba.',
        scheduledDate: _instante(DateTime.now().add(const Duration(minutes: 1))),
        notificationDetails: _detalles,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('Alertas: fallo el aviso programado de prueba: $e');
    }
  }

  tz.TZDateTime _instante(DateTime local) => instanteUtc(local);
}

/// Un instante exacto en el tiempo, expresado en UTC. No depende de la zona
/// horaria del celular ni de inicializar la base de zonas horarias.
tz.TZDateTime instanteUtc(DateTime local) {
  final u = local.toUtc();
  return tz.TZDateTime.utc(u.year, u.month, u.day, u.hour, u.minute, u.second);
}

final servicioAlertasProvider = Provider<ServicioAlertas>(
  (ref) => ServicioAlertas(ref),
);
