class ItemChecklist {
  const ItemChecklist({
    required this.titulo,
    required this.completado,
  });

  final String titulo;
  final bool completado;

  factory ItemChecklist.fromMap(Map<String, dynamic> mapa) {
    return ItemChecklist(
      titulo: mapa['titulo'] as String? ?? '',
      completado: mapa['completado'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'completado': completado,
    };
  }

  ItemChecklist copiarCon({String? titulo, bool? completado}) {
    return ItemChecklist(
      titulo: titulo ?? this.titulo,
      completado: completado ?? this.completado,
    );
  }
}
