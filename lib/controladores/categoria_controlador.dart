import '../entidades/categoria.dart';
import '../servicios/categoria_servicio.dart';

class CategoriaControlador {
  CategoriaControlador({required this.categoriaServicio});

  final CategoriaServicio categoriaServicio;

  Stream<List<Categoria>> observarCategorias() {
    return categoriaServicio.observarCategorias();
  }

  Future<Categoria?> obtenerPorId(String categoriaId) {
    return categoriaServicio.obtenerPorId(categoriaId);
  }
}
