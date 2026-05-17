class Usuario {
  const Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.tema,
    required this.notificaciones,
  });

  final String id;
  final String nombre;
  final String apellido;
  final String correo;
  final String tema;
  final bool notificaciones;

  String get nombreCompleto => '$nombre $apellido'.trim();

  String get inicial =>
      nombre.isNotEmpty ? nombre.substring(0, 1).toUpperCase() : '?';

  factory Usuario.fromFirestore(String id, Map<String, dynamic> datos) {
    return Usuario(
      id: id,
      nombre: datos['nombre'] as String? ?? '',
      apellido: datos['apellido'] as String? ?? '',
      correo: datos['correo'] as String? ?? '',
      tema: datos['tema'] as String? ?? 'light',
      notificaciones: datos['notificaciones'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'tema': tema,
      'notificaciones': notificaciones,
    };
  }

  Usuario copiarCon({
    String? nombre,
    String? apellido,
    String? correo,
    String? tema,
    bool? notificaciones,
  }) {
    return Usuario(
      id: id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      correo: correo ?? this.correo,
      tema: tema ?? this.tema,
      notificaciones: notificaciones ?? this.notificaciones,
    );
  }
}
