import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../componentes/checklist_evento_detalle.dart';
import '../componentes/etiqueta_prioridad.dart';
import '../componentes/icono_categoria.dart';
import '../componentes/modal_evento.dart';
import '../controladores/proveedores.dart';
import '../entidades/categoria.dart';
import '../utilidades/formato.dart';

class DetalleEventoPantalla extends ConsumerWidget {
  const DetalleEventoPantalla({super.key, required this.eventoId});

  final String eventoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventos = ref.watch(eventosProvider).valueOrNull ?? [];
    final categorias = ref.watch(categoriasProvider).valueOrNull ?? [];
    final evento = eventos.where((e) => e.id == eventoId).firstOrNull;

    if (evento == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Categoria? categoria;
    for (final c in categorias) {
      if (c.id == evento.categoriaId) {
        categoria = c;
        break;
      }
    }

    final tema = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    onPressed: () =>
                        mostrarModalEvento(context, eventoExistente: evento),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  const SizedBox(width: 4),
                  IconButton.filledTonal(
                    onPressed: () async {
                      await ref
                          .read(eventoControladorProvider)
                          .eliminar(evento.id);
                      if (context.mounted) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconoCategoria(
                        categoriaId: evento.categoriaId,
                        tamano: 56,
                        iconoFallback: evento.icono,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              evento.titulo,
                              style: tema.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${Formato.encabezadoDia(evento.fechaHora)} · ${Formato.hora(evento.fechaHora)}',
                              style: tema.textTheme.bodyMedium?.copyWith(
                                color: tema.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              children: [
                                if (categoria != null)
                                  Chip(
                                    label: Text(categoria.nombre),
                                    avatar: const Icon(Icons.circle, size: 8),
                                  ),
                                EtiquetaPrioridad(prioridad: evento.prioridad),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (evento.ubicacion.isNotEmpty)
                    _DetalleCard(
                      icono: Icons.location_on_outlined,
                      etiqueta: 'UBICACIÓN',
                      valor: evento.ubicacion,
                    ),
                  if (evento.monto > 0)
                    _DetalleCard(
                      icono: Icons.account_balance_wallet_outlined,
                      etiqueta: 'MONTO',
                      valor: Formato.moneda(evento.monto),
                    ),
                  if (evento.recordatorio)
                    const _DetalleCard(
                      icono: Icons.notifications_none,
                      etiqueta: 'RECORDATORIOS',
                      valor: '2 horas antes',
                    ),
                  if (evento.descripcion.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'NOTAS',
                      style: tema.textTheme.labelSmall?.copyWith(
                        color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(evento.descripcion),
                      ),
                    ),
                  ],
                  if (evento.checklist.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    ChecklistEventoDetalle(evento: evento),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () =>
                      mostrarModalEvento(context, eventoExistente: evento),
                  child: const Text('Editar evento'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _DetalleCard extends StatelessWidget {
  const _DetalleCard({
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });

  final IconData icono;
  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icono, color: tema.colorScheme.onSurface.withValues(alpha: 0.45)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    etiqueta,
                    style: tema.textTheme.labelSmall?.copyWith(
                      color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    valor,
                    style: tema.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
