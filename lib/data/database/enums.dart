// Enumeraciones guardadas como texto (su nombre) en la base de datos.
// IMPORTANTE: no renombrar valores existentes sin una migración.

enum TipoMovimiento { ingreso, gasto }

/// De dónde nació un movimiento de caja.
enum OrigenMovimiento { manual, pagoFiado, pagoEmpleado }

enum TipoFiado { compra, pago }

enum TipoPago { hora, dia, semana, quincena, mes }
