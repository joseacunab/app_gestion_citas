import 'package:firebase_auth/firebase_auth.dart';

import '../entidades/usuario.dart';
import '../servicios/usuario_servicio.dart';
import 'excepcion_controlador.dart';

class UsuarioControlador {
  UsuarioControlador({
    required this.usuarioServicio,
    required this.usuarioId,
  });

  final UsuarioServicio usuarioServicio;
  final String? usuarioId;

  Stream<Usuario?> observarUsuario() {
    if (usuarioId == null) return const Stream.empty();
    return usuarioServicio.observarUsuario(usuarioId!);
  }

  Future<void> crearPerfil(Usuario usuario) async {
    if (usuario.id.isEmpty) {
      throw ExcepcionControlador('El perfil requiere un id de usuario.');
    }
    await usuarioServicio.crearUsuario(usuario.id, usuario);
  }

  Future<void> asegurarPerfilSiFalta(User authUser) async {
    if (usuarioId == null) return;

    final existente = await usuarioServicio
        .observarUsuario(usuarioId!)
        .first;

    if (existente != null) return;

    await crearPerfil(
      Usuario(
        id: usuarioId!,
        nombre: authUser.displayName?.split(' ').first ?? 'Usuario',
        apellido: '',
        correo: authUser.email ?? '',
        tema: 'light',
        notificaciones: true,
      ),
    );
  }

  Future<void> actualizarTema(bool oscuro) async {
    _requerirUsuario();
    await usuarioServicio.actualizarUsuario(usuarioId!, {
      'tema': oscuro ? 'dark' : 'light',
    });
  }

  Future<void> actualizarNotificaciones(bool activas) async {
    _requerirUsuario();
    await usuarioServicio.actualizarUsuario(usuarioId!, {
      'notificaciones': activas,
    });
  }

  void _requerirUsuario() {
    if (usuarioId == null) {
      throw ExcepcionControlador('Debes iniciar sesión para actualizar el perfil.');
    }
  }
}
