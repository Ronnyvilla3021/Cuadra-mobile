// Enumeraciones guardadas como texto (su nombre) en la base de datos.
// IMPORTANTE: no renombrar valores existentes sin una migración.

enum TipoMovimiento { ingreso, gasto }

// De dónde nació un movimiento de caja.
// - manual: lo registró el usuario
// - prestamo: dinero entregado en un préstamo
// - cobroPrestamo: pago recibido de un préstamo
// - pagoEmpleado: pago a un empleado
enum OrigenMovimiento { manual, prestamo, cobroPrestamo, pagoEmpleado }

enum TipoPago { hora, dia, semana, quincena, mes }
