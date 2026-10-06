/// Controla cada cuánto tiempo se puede mostrar algo (por ejemplo, un anuncio).
/// El reloj empieza a contar desde que se crea el limitador.
class LimitadorFrecuencia {
  LimitadorFrecuencia({required this.intervalo, DateTime Function()? reloj})
      : _reloj = reloj ?? DateTime.now {
    _ultima = _reloj();
  }

  final Duration intervalo;
  final DateTime Function() _reloj;
  late DateTime _ultima;

  bool get puedeMostrar => _reloj().difference(_ultima) >= intervalo;

  /// Anota que acaba de mostrarse y reinicia la cuenta.
  void registrar() => _ultima = _reloj();
}
