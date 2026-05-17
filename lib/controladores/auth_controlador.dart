import 'package:firebase_auth/firebase_auth.dart';

import '../servicios/auth_servicio.dart';
import 'excepcion_controlador.dart';

class AuthControlador {
  AuthControlador({required this.authServicio});

  final AuthServicio authServicio;

  Stream<User?> observarSesion() => authServicio.cambiosUsuario;

  User? get usuarioActual => authServicio.usuarioActual;

  String? get usuarioId => authServicio.usuarioId;

  Future<void> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    if (correo.trim().isEmpty || contrasena.isEmpty) {
      throw ExcepcionControlador('Correo y contraseña son obligatorios.');
    }
    await authServicio.iniciarSesion(
      correo: correo,
      contrasena: contrasena,
    );
  }

  Future<String> registrar({
    required String correo,
    required String contrasena,
    required String nombre,
    required String apellido,
  }) async {
    if (correo.trim().isEmpty || !correo.contains('@')) {
      throw ExcepcionControlador('Correo inválido.');
    }
    if (contrasena.length < 6) {
      throw ExcepcionControlador('La contraseña debe tener al menos 6 caracteres.');
    }
    final credencial = await authServicio.registrar(
      correo: correo,
      contrasena: contrasena,
      nombre: nombre,
      apellido: apellido,
    );
    final uid = credencial.user?.uid;
    if (uid == null) {
      throw ExcepcionControlador('No se pudo crear la cuenta.');
    }
    return uid;
  }

  Future<void> cerrarSesion() => authServicio.cerrarSesion();
}
