/// Excepción de reglas de negocio en la capa de controladores.
class ExcepcionControlador implements Exception {
  ExcepcionControlador(this.mensaje);

  final String mensaje;

  @override
  String toString() => mensaje;
}
