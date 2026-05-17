import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entidades/categoria.dart';
import '../entidades/evento.dart';
import '../entidades/nota.dart';
import '../entidades/pago.dart';
import '../entidades/usuario.dart';
import '../servicios/auth_servicio.dart';
import '../servicios/categoria_servicio.dart';
import '../servicios/evento_servicio.dart';
import '../servicios/nota_servicio.dart';
import '../servicios/pago_servicio.dart';
import '../servicios/usuario_servicio.dart';
import 'auth_controlador.dart';
import 'categoria_controlador.dart';
import 'evento_controlador.dart';
import 'nota_controlador.dart';
import 'pago_controlador.dart';
import 'usuario_controlador.dart';

// --- Services (solo inyección; la UI no debe usarlos directamente) ---

final authServicioProvider = Provider((ref) => AuthServicio());
final usuarioServicioProvider = Provider((ref) => UsuarioServicio());
final categoriaServicioProvider = Provider((ref) => CategoriaServicio());
final eventoServicioProvider = Provider((ref) => EventoServicio());
final pagoServicioProvider = Provider((ref) => PagoServicio());
final notaServicioProvider = Provider((ref) => NotaServicio());

// --- Controllers ---

final authControladorProvider = Provider(
  (ref) => AuthControlador(authServicio: ref.watch(authServicioProvider)),
);

final usuarioControladorProvider = Provider(
  (ref) => UsuarioControlador(
    usuarioServicio: ref.watch(usuarioServicioProvider),
    usuarioId: ref.watch(usuarioIdProvider),
  ),
);

final categoriaControladorProvider = Provider(
  (ref) => CategoriaControlador(
    categoriaServicio: ref.watch(categoriaServicioProvider),
  ),
);

final eventoControladorProvider = Provider(
  (ref) => EventoControlador(
    eventoServicio: ref.watch(eventoServicioProvider),
    usuarioId: ref.watch(usuarioIdProvider),
  ),
);

final pagoControladorProvider = Provider(
  (ref) => PagoControlador(
    pagoServicio: ref.watch(pagoServicioProvider),
    usuarioId: ref.watch(usuarioIdProvider),
  ),
);

final notaControladorProvider = Provider(
  (ref) => NotaControlador(
    notaServicio: ref.watch(notaServicioProvider),
    usuarioId: ref.watch(usuarioIdProvider),
  ),
);

// --- Auth / sesión ---

final usuarioAuthProvider = StreamProvider<User?>((ref) {
  return ref.watch(authControladorProvider).observarSesion();
});

final usuarioIdProvider = Provider<String?>((ref) {
  ref.watch(usuarioAuthProvider);
  return ref.watch(authControladorProvider).usuarioId;
});

// --- Datos (StreamProviders → controllers) ---

final usuarioProvider = StreamProvider<Usuario?>((ref) {
  return ref.watch(usuarioControladorProvider).observarUsuario();
});

final categoriasProvider = StreamProvider<List<Categoria>>((ref) {
  return ref.watch(categoriaControladorProvider).observarCategorias();
});

final eventosProvider = StreamProvider<List<Evento>>((ref) {
  return ref.watch(eventoControladorProvider).observarEventos();
});

final pagosProvider = StreamProvider<List<Pago>>((ref) {
  return ref.watch(pagoControladorProvider).observarPagos();
});

final notasProvider = StreamProvider<List<Nota>>((ref) {
  return ref.watch(notaControladorProvider).observarNotas();
});

// --- UI state ---

final indiceNavegacionProvider = StateProvider<int>((ref) => 0);

final fechaCalendarioProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

final diaSeleccionadoProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

final temaOscuroProvider = StateProvider<bool>((ref) {
  final usuario = ref.watch(usuarioProvider).valueOrNull;
  return usuario?.tema == 'dark';
});
