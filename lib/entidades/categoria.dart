class Categoria {
  const Categoria({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.color,
    this.usuarioId,
  });

  final String id;
  final String nombre;
  final String icono;
  final String color;

  /// `null` = categoría del sistema (predeterminada).
  final String? usuarioId;

  bool get esSistema => usuarioId == null && id.startsWith('sys_');
  bool get esPersonalizada => usuarioId != null;

  factory Categoria.fromFirestore(String id, Map<String, dynamic> datos) {
    return Categoria(
      id: id,
      nombre: datos['nombre'] as String? ?? '',
      icono: datos['icono'] as String? ?? 'category',
      color: datos['color'] as String? ?? '#4A80F0',
      usuarioId: datos['usuarioId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final mapa = <String, dynamic>{
      'nombre': nombre,
      'icono': icono,
      'color': color,
    };
    if (usuarioId != null) {
      mapa['usuarioId'] = usuarioId;
    }
    return mapa;
  }

  Categoria copiarCon({
    String? nombre,
    String? icono,
    String? color,
  }) {
    return Categoria(
      id: id,
      nombre: nombre ?? this.nombre,
      icono: icono ?? this.icono,
      color: color ?? this.color,
      usuarioId: usuarioId,
    );
  }
}
