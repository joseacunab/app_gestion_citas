import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../componentes/modal_evento.dart';
import '../controladores/proveedores.dart';
import '../utilidades/colores_util.dart';
import 'historial_pantalla.dart';

class PerfilPantalla extends ConsumerWidget {
  const PerfilPantalla({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final usuario = ref.watch(usuarioProvider).valueOrNull;
    final eventos = ref.watch(eventosProvider).valueOrNull ?? [];
    final categorias = ref.watch(categoriasProvider).valueOrNull ?? [];

    final total = eventos.length;
    final pendientes = eventos.where((e) => !e.completado).length;
    final completados = eventos.where((e) => e.completado).length;
    final oscuro = ref.watch(temaOscuroProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A80F0).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    usuario?.inicial ?? '?',
                    style: tema.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4A80F0),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuario?.nombreCompleto ?? 'Usuario',
                        style: tema.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        usuario?.correo ?? '',
                        style: tema.textTheme.bodyMedium?.copyWith(
                          color: tema.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _StatCard(valor: '$total', etiqueta: 'EVENTOS'),
                const SizedBox(width: 10),
                _StatCard(valor: '$pendientes', etiqueta: 'PENDIENTES'),
                const SizedBox(width: 10),
                _StatCard(valor: '$completados', etiqueta: 'COMPLETADOS'),
              ],
            ),
            const SizedBox(height: 28),
            _tituloSeccion('PREFERENCIAS'),
            const SizedBox(height: 10),
            _FilaPreferencia(
              icono: Icons.dark_mode_outlined,
              titulo: 'Tema',
              trailing: Text(oscuro ? 'Oscuro' : 'Claro'),
              alTocar: () async {
                final nuevo = !oscuro;
                ref.read(temaOscuroProvider.notifier).state = nuevo;
                await ref.read(usuarioControladorProvider).actualizarTema(nuevo);
              },
            ),
            const SizedBox(height: 8),
            _FilaPreferencia(
              icono: Icons.notifications_none_outlined,
              titulo: 'Notificaciones',
              trailing: Switch(
                value: usuario?.notificaciones ?? true,
                onChanged: (v) async {
                  await ref
                      .read(usuarioControladorProvider)
                      .actualizarNotificaciones(v);
                },
              ),
            ),
            const SizedBox(height: 28),
            _tituloSeccion('ACTIVIDAD'),
            const SizedBox(height: 10),
            _FilaPreferencia(
              icono: Icons.history,
              titulo: 'Historial',
              trailing: const Icon(Icons.chevron_right),
              alTocar: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistorialPantalla()),
              ),
            ),
            const SizedBox(height: 28),
            _tituloSeccion('CATEGORÍAS'),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  for (var i = 0; i < categorias.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: ColoresUtil.desdeHex(categorias[i].color),
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Text(categorias[i].nombre),
                      trailing: Text(
                        '${eventos.where((e) => e.categoriaId == categorias[i].id).length}',
                        style: tema.textTheme.bodyMedium?.copyWith(
                          color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),
            _tituloSeccion('CUENTA'),
            const SizedBox(height: 10),
            _FilaPreferencia(
              icono: Icons.person_outline,
              titulo: 'Cerrar sesión',
              trailing: const Icon(Icons.logout),
              alTocar: () => ref.read(authControladorProvider).cerrarSesion(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarModalEvento(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _tituloSeccion(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        color: Color(0xFF74777F),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.valor, required this.etiqueta});

  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(
                valor,
                style: tema.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                etiqueta,
                style: tema.textTheme.labelSmall?.copyWith(
                  color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilaPreferencia extends StatelessWidget {
  const _FilaPreferencia({
    required this.icono,
    required this.titulo,
    required this.trailing,
    this.alTocar,
  });

  final IconData icono;
  final String titulo;
  final Widget trailing;
  final VoidCallback? alTocar;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: alTocar,
        leading: Icon(icono),
        title: Text(titulo),
        trailing: trailing,
      ),
    );
  }
}
