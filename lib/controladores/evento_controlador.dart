import '../entidades/evento.dart';
import '../entidades/item_checklist.dart';
import '../servicios/evento_servicio.dart';
import 'excepcion_controlador.dart';

/// Datos del formulario de evento (modal crear/editar).
class DatosFormularioEvento {
  const DatosFormularioEvento({
    this.eventoId,
    required this.titulo,
    required this.descripcion,
    required this.fechaHora,
    required this.ubicacion,
    required this.categoriaId,
    required this.prioridad,
    required this.recordatorio,
    required this.monto,
    required this.icono,
    this.completado = false,
    this.completadoEn,
    this.checklist = const [],
  });

  final String? eventoId;
  final String titulo;
  final String descripcion;
  final DateTime fechaHora;
  final String ubicacion;
  final String categoriaId;
  final String prioridad;
  final bool recordatorio;
  final num monto;
  final String icono;
  final bool completado;
  final DateTime? completadoEn;
  final List<ItemChecklist> checklist;
}

class EventoControlador {
  EventoControlador({
    required this.eventoServicio,
    required this.usuarioId,
  });

  final EventoServicio eventoServicio;
  final String? usuarioId;

  Stream<List<Evento>> observarEventos() {
    if (usuarioId == null) return const Stream.empty();
    return eventoServicio.observarEventos(usuarioId!);
  }

  Future<String> crearEvento(Evento evento) async {
    _requerirUsuario();
    _validarEvento(evento);

    final eventoConUsuario = _conUsuarioId(evento);
    return eventoServicio.crear(eventoConUsuario);
  }

  Future<void> guardarDesdeFormulario(DatosFormularioEvento datos) async {
    _requerirUsuario();
    if (datos.titulo.trim().isEmpty) {
      throw ExcepcionControlador('El título del evento es obligatorio.');
    }
    if (datos.categoriaId.isEmpty) {
      throw ExcepcionControlador('Seleccioná una categoría.');
    }

    final evento = Evento(
      id: datos.eventoId ?? '',
      usuarioId: usuarioId!,
      titulo: datos.titulo.trim(),
      descripcion: datos.descripcion.trim(),
      fechaHora: datos.fechaHora,
      ubicacion: datos.ubicacion.trim(),
      categoriaId: datos.categoriaId,
      prioridad: datos.prioridad,
      completado: datos.completado,
      completadoEn: datos.completadoEn,
      recordatorio: datos.recordatorio,
      monto: datos.monto,
      icono: datos.icono,
      checklist: datos.checklist,
    );

    if (datos.eventoId != null) {
      await eventoServicio.actualizar(datos.eventoId!, evento.toMap());
    } else {
      await eventoServicio.crear(evento);
    }
  }

  Future<void> actualizar(String eventoId, Map<String, dynamic> datos) async {
    _requerirUsuario();
    if (eventoId.isEmpty) {
      throw ExcepcionControlador('Id de evento inválido.');
    }
    await eventoServicio.actualizar(eventoId, {
      ...datos,
      'usuarioId': usuarioId!,
    });
  }

  Future<void> actualizarChecklist(
    String eventoId,
    List<ItemChecklist> checklist,
  ) async {
    await actualizar(eventoId, {
      'checklist': checklist.map((e) => e.toMap()).toList(),
    });
  }

  Future<void> marcarCompletado(String eventoId, bool completado) async {
    _requerirUsuario();
    if (eventoId.isEmpty) {
      throw ExcepcionControlador('Id de evento inválido.');
    }
    await eventoServicio.marcarCompletado(eventoId, completado);
  }

  Future<void> eliminar(String eventoId) async {
    _requerirUsuario();
    if (eventoId.isEmpty) {
      throw ExcepcionControlador('Id de evento inválido.');
    }
    await eventoServicio.eliminar(eventoId);
  }

  Evento _conUsuarioId(Evento evento) {
    return Evento(
      id: evento.id,
      usuarioId: usuarioId!,
      titulo: evento.titulo,
      descripcion: evento.descripcion,
      fechaHora: evento.fechaHora,
      ubicacion: evento.ubicacion,
      categoriaId: evento.categoriaId,
      prioridad: evento.prioridad,
      completado: evento.completado,
      completadoEn: evento.completadoEn,
      recordatorio: evento.recordatorio,
      monto: evento.monto,
      icono: evento.icono,
      checklist: evento.checklist,
    );
  }

  void _validarEvento(Evento evento) {
    if (evento.titulo.trim().isEmpty) {
      throw ExcepcionControlador('El título del evento es obligatorio.');
    }
    if (evento.categoriaId.isEmpty) {
      throw ExcepcionControlador('Seleccioná una categoría.');
    }
  }

  void _requerirUsuario() {
    if (usuarioId == null || usuarioId!.isEmpty) {
      throw ExcepcionControlador(
        'Debes iniciar sesión para gestionar eventos.',
      );
    }
  }
}
