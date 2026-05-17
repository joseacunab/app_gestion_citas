class Categoria {
  const Categoria({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.color,
  });

  final String id;
  final String nombre;
  final String icono;
  final String color;

  factory Categoria.fromFirestore(String id, Map<String, dynamic> datos) {
    return Categoria(
      id: id,
      nombre: datos['nombre'] as String? ?? '',
      icono: datos['icono'] as String? ?? 'category',
      color: datos['color'] as String? ?? '#4A80F0',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'icono': icono,
      'color': color,
    };
  }
}
