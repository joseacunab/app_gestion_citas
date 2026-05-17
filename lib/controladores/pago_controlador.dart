import '../entidades/pago.dart';
import '../servicios/pago_servicio.dart';
import 'excepcion_controlador.dart';

class DatosFormularioPago {
  const DatosFormularioPago({
    this.pagoId,
    required this.titulo,
    required this.monto,
    required this.fechaVencimiento,
    required this.categoriaId,
    required this.color,
    this.pagado = false,
    this.pagadoEn,
  });

  final String? pagoId;
  final String titulo;
  final num monto;
  final DateTime fechaVencimiento;
  final String categoriaId;
  final String color;
  final bool pagado;
  final DateTime? pagadoEn;
}

class PagoControlador {
  PagoControlador({
    required this.pagoServicio,
    required this.usuarioId,
  });

  final PagoServicio pagoServicio;
  final String? usuarioId;

  Stream<List<Pago>> observarPagos() {
    if (usuarioId == null) return const Stream.empty();
    return pagoServicio.observarPagos(usuarioId!);
  }

  Future<String> crearPago(Pago pago) async {
    _requerirUsuario();
    _validarPago(pago);
    return pagoServicio.crear(_conUsuarioId(pago));
  }

  Future<void> guardarDesdeFormulario(DatosFormularioPago datos) async {
    _requerirUsuario();
    if (datos.titulo.trim().isEmpty) {
      throw ExcepcionControlador('El título del pago es obligatorio.');
    }
    if (datos.categoriaId.isEmpty) {
      throw ExcepcionControlador('Seleccioná una categoría.');
    }

    final pago = Pago(
      id: datos.pagoId ?? '',
      usuarioId: usuarioId!,
      titulo: datos.titulo.trim(),
      monto: datos.monto,
      fechaVencimiento: datos.fechaVencimiento,
      categoriaId: datos.categoriaId,
      pagado: datos.pagado,
      pagadoEn: datos.pagadoEn,
      color: datos.color,
    );

    if (datos.pagoId != null) {
      await pagoServicio.actualizar(datos.pagoId!, pago.toMap());
    } else {
      await pagoServicio.crear(pago);
    }
  }

  Future<void> marcarPagado(String pagoId, bool pagado) async {
    _requerirUsuario();
    if (pagoId.isEmpty) {
      throw ExcepcionControlador('Id de pago inválido.');
    }
    await pagoServicio.marcarPagado(pagoId, pagado);
  }

  Future<void> eliminar(String pagoId) async {
    _requerirUsuario();
    await pagoServicio.eliminar(pagoId);
  }

  Pago _conUsuarioId(Pago pago) {
    return Pago(
      id: pago.id,
      usuarioId: usuarioId!,
      titulo: pago.titulo,
      monto: pago.monto,
      fechaVencimiento: pago.fechaVencimiento,
      categoriaId: pago.categoriaId,
      pagado: pago.pagado,
      pagadoEn: pago.pagadoEn,
      color: pago.color,
    );
  }

  void _validarPago(Pago pago) {
    if (pago.titulo.trim().isEmpty) {
      throw ExcepcionControlador('El título del pago es obligatorio.');
    }
  }

  void _requerirUsuario() {
    if (usuarioId == null || usuarioId!.isEmpty) {
      throw ExcepcionControlador('Debes iniciar sesión para gestionar pagos.');
    }
  }
}
