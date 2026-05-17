import '../entidades/nota.dart';
import '../servicios/nota_servicio.dart';
import 'excepcion_controlador.dart';

class DatosFormularioNota {
  const DatosFormularioNota({
    this.notaId,
    required this.texto,
    required this.fecha,
    required this.icono,
    required this.colorPrincipal,
    required this.colorFondo,
  });

  final String? notaId;
  final String texto;
  final DateTime fecha;
  final String icono;
  final String colorPrincipal;
  final String colorFondo;
}

class NotaControlador {
  NotaControlador({
    required this.notaServicio,
    required this.usuarioId,
  });

  final NotaServicio notaServicio;
  final String? usuarioId;

  Stream<List<Nota>> observarNotas() {
    if (usuarioId == null) return const Stream.empty();
    return notaServicio.observarNotas(usuarioId!);
  }

  Future<String> crearNota(Nota nota) async {
    _requerirUsuario();
    _validarNota(nota);
    return notaServicio.crear(_conUsuarioId(nota));
  }

  Future<void> guardarDesdeFormulario(DatosFormularioNota datos) async {
    _requerirUsuario();
    if (datos.texto.trim().isEmpty) {
      throw ExcepcionControlador('El texto de la nota es obligatorio.');
    }

    final nota = Nota(
      id: datos.notaId ?? '',
      usuarioId: usuarioId!,
      texto: datos.texto.trim(),
      fecha: datos.fecha,
      icono: datos.icono,
      colorPrincipal: datos.colorPrincipal,
      colorFondo: datos.colorFondo,
    );

    if (datos.notaId != null) {
      await notaServicio.actualizar(datos.notaId!, nota.toMap());
    } else {
      await notaServicio.crear(nota);
    }
  }

  Future<void> eliminar(String notaId) async {
    _requerirUsuario();
    await notaServicio.eliminar(notaId);
  }

  Nota _conUsuarioId(Nota nota) {
    return Nota(
      id: nota.id,
      usuarioId: usuarioId!,
      texto: nota.texto,
      fecha: nota.fecha,
      icono: nota.icono,
      colorPrincipal: nota.colorPrincipal,
      colorFondo: nota.colorFondo,
    );
  }

  void _validarNota(Nota nota) {
    if (nota.texto.trim().isEmpty) {
      throw ExcepcionControlador('El texto de la nota es obligatorio.');
    }
  }

  void _requerirUsuario() {
    if (usuarioId == null || usuarioId!.isEmpty) {
      throw ExcepcionControlador('Debes iniciar sesión para gestionar notas.');
    }
  }
}
