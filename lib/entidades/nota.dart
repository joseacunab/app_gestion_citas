import '../utilidades/fechas_firestore.dart';

class Nota {
  const Nota({
    required this.id,
    required this.usuarioId,
    required this.texto,
    required this.fecha,
    required this.icono,
    required this.colorPrincipal,
    required this.colorFondo,
  });

  final String id;
  final String usuarioId;
  final String texto;
  final DateTime fecha;
  final String icono;
  final String colorPrincipal;
  final String colorFondo;

  factory Nota.fromFirestore(String id, Map<String, dynamic> datos) {
    return Nota(
      id: id,
      usuarioId: datos['usuarioId'] as String? ?? '',
      texto: datos['texto'] as String? ?? '',
      fecha: FechasFirestore.soloFecha(
        FechasFirestore.desdeFirestore(datos['fecha']),
      ),
      icono: datos['icono'] as String? ?? 'note',
      colorPrincipal: datos['colorPrincipal'] as String? ?? '#4A80F0',
      colorFondo: datos['colorFondo'] as String? ?? '#EEF3F6',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'texto': texto,
      'fecha': FechasFirestore.soloFecha(fecha),
      'icono': icono,
      'colorPrincipal': colorPrincipal,
      'colorFondo': colorFondo,
    };
  }

  Nota copiarCon({
    String? texto,
    DateTime? fecha,
    String? icono,
    String? colorPrincipal,
    String? colorFondo,
  }) {
    return Nota(
      id: id,
      usuarioId: usuarioId,
      texto: texto ?? this.texto,
      fecha: fecha ?? this.fecha,
      icono: icono ?? this.icono,
      colorPrincipal: colorPrincipal ?? this.colorPrincipal,
      colorFondo: colorFondo ?? this.colorFondo,
    );
  }
}
