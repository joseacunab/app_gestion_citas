import '../entidades/categoria.dart';
import '../servicios/categoria_servicio.dart';
import '../utilidades/categorias_sistema.dart';
import 'excepcion_controlador.dart';

class DatosNuevaCategoria {
  const DatosNuevaCategoria({
    required this.nombre,
    required this.color,
    required this.icono,
  });

  final String nombre;
  final String color;
  final String icono;
}

class CategoriaControlador {
  CategoriaControlador({
    required this.categoriaServicio,
    required this.usuarioId,
  });

  final CategoriaServicio categoriaServicio;
  final String? usuarioId;

  Stream<List<Categoria>> observarCategoriasCombinadas() {
    if (usuarioId == null) {
      return Stream.value(CategoriasSistema.todas);
    }
    return categoriaServicio.observarCategoriasUsuario(usuarioId!).map(
      (personalizadas) => [...CategoriasSistema.todas, ...personalizadas],
    );
  }

  Future<String> crearCategoriaPersonalizada(DatosNuevaCategoria datos) async {
    _requerirUsuario();

    final nombre = datos.nombre.trim();
    if (nombre.isEmpty) {
      throw ExcepcionControlador('El nombre es obligatorio.');
    }
    if (nombre.length > 25) {
      throw ExcepcionControlador('Máximo 25 caracteres.');
    }

    final combinadas = await observarCategoriasCombinadas().first;
    final duplicado = combinadas.any(
      (c) => c.nombre.toLowerCase() == nombre.toLowerCase(),
    );
    if (duplicado) {
      throw ExcepcionControlador('Ya existe una categoría con ese nombre.');
    }

    final categoria = Categoria(
      id: '',
      nombre: nombre,
      icono: datos.icono,
      color: datos.color,
      usuarioId: usuarioId,
    );

    return categoriaServicio.crear(categoria);
  }

  Future<Categoria?> obtenerPorId(String categoriaId) async {
    final sistema = CategoriasSistema.buscarPorId(categoriaId);
    if (sistema != null) return sistema;
    return categoriaServicio.obtenerPorId(categoriaId);
  }

  void _requerirUsuario() {
    if (usuarioId == null || usuarioId!.isEmpty) {
      throw ExcepcionControlador(
        'Debes iniciar sesión para crear categorías.',
      );
    }
  }
}
