import '../entidades/categoria.dart';
import 'categorias_sistema.dart';

class CategoriasUtil {
  CategoriasUtil._();

  static Categoria? buscarPorId(String id, List<Categoria> categorias) {
    for (final c in categorias) {
      if (c.id == id) return c;
    }
    return CategoriasSistema.buscarPorId(id);
  }
}
