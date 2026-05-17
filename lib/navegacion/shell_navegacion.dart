import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../componentes/barra_navegacion.dart';
import '../controladores/proveedores.dart';
import '../pantallas/calendario_pantalla.dart';
import '../pantallas/inicio_pantalla.dart';
import '../pantallas/notas_pantalla.dart';
import '../pantallas/pagos_pantalla.dart';
import '../pantallas/perfil_pantalla.dart';

class ShellNavegacion extends ConsumerStatefulWidget {
  const ShellNavegacion({super.key});

  @override
  ConsumerState<ShellNavegacion> createState() => _ShellNavegacionState();
}

class _ShellNavegacionState extends ConsumerState<ShellNavegacion> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _asegurarPerfil());
  }

  Future<void> _asegurarPerfil() async {
    final authUser = ref.read(authControladorProvider).usuarioActual;
    if (authUser == null) return;

    await ref.read(usuarioControladorProvider).asegurarPerfilSiFalta(authUser);
  }

  @override
  Widget build(BuildContext context) {
    final indice = ref.watch(indiceNavegacionProvider);

    return Scaffold(
      body: IndexedStack(
        index: indice,
        children: [
          InicioPantalla(
            alVerCalendario: () =>
                ref.read(indiceNavegacionProvider.notifier).state = 1,
            alVerPagos: () =>
                ref.read(indiceNavegacionProvider.notifier).state = 2,
          ),
          const CalendarioPantalla(),
          const PagosPantalla(),
          const NotasPantalla(),
          const PerfilPantalla(),
        ],
      ),
      bottomNavigationBar: BarraNavegacion(
        indiceActual: indice,
        alSeleccionar: (i) =>
            ref.read(indiceNavegacionProvider.notifier).state = i,
      ),
    );
  }
}

