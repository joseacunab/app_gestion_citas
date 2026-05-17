import '../utilidades/fechas_firestore.dart';
import 'item_checklist.dart';

class Evento {
  const Evento({
    required this.id,
    required this.usuarioId,
    required this.titulo,
    required this.descripcion,
    required this.fechaHora,
    required this.ubicacion,
    required this.categoriaId,
    required this.prioridad,
    required this.completado,
    required this.completadoEn,
    required this.recordatorio,
    required this.monto,
    required this.icono,
    required this.checklist,
  });

  final String id;
  final String usuarioId;
  final String titulo;
  final String descripcion;
  final DateTime fechaHora;
  final String ubicacion;
  final String categoriaId;
  final String prioridad;
  final bool completado;
  final DateTime? completadoEn;
  final bool recordatorio;
  final num monto;
  final String icono;
  final List<ItemChecklist> checklist;

  factory Evento.fromFirestore(String id, Map<String, dynamic> datos) {
    final lista = datos['checklist'] as List<dynamic>? ?? [];
    return Evento(
      id: id,
      usuarioId: datos['usuarioId'] as String? ?? '',
      titulo: datos['titulo'] as String? ?? '',
      descripcion: datos['descripcion'] as String? ?? '',
      fechaHora: FechasFirestore.desdeFirestore(datos['fechaHora']),
      ubicacion: datos['ubicacion'] as String? ?? '',
      categoriaId: datos['categoriaId'] as String? ?? '',
      prioridad: datos['prioridad'] as String? ?? 'normal',
      completado: datos['completado'] as bool? ?? false,
      completadoEn: FechasFirestore.desdeFirestoreNullable(datos['completadoEn']),
      recordatorio: datos['recordatorio'] as bool? ?? false,
      monto: datos['monto'] as num? ?? 0,
      icono: datos['icono'] as String? ?? 'event',
      checklist: lista
          .map((e) => ItemChecklist.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'titulo': titulo,
      'descripcion': descripcion,
      'fechaHora': fechaHora,
      'ubicacion': ubicacion,
      'categoriaId': categoriaId,
      'prioridad': prioridad,
      'completado': completado,
      'completadoEn': completadoEn,
      'recordatorio': recordatorio,
      'monto': monto,
      'icono': icono,
      'checklist': checklist.map((e) => e.toMap()).toList(),
    };
  }

  Evento copiarCon({
    String? titulo,
    String? descripcion,
    DateTime? fechaHora,
    String? ubicacion,
    String? categoriaId,
    String? prioridad,
    bool? completado,
    DateTime? completadoEn,
    bool? recordatorio,
    num? monto,
    String? icono,
    List<ItemChecklist>? checklist,
  }) {
    return Evento(
      id: id,
      usuarioId: usuarioId,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fechaHora: fechaHora ?? this.fechaHora,
      ubicacion: ubicacion ?? this.ubicacion,
      categoriaId: categoriaId ?? this.categoriaId,
      prioridad: prioridad ?? this.prioridad,
      completado: completado ?? this.completado,
      completadoEn: completadoEn,
      recordatorio: recordatorio ?? this.recordatorio,
      monto: monto ?? this.monto,
      icono: icono ?? this.icono,
      checklist: checklist ?? this.checklist,
    );
  }
}
