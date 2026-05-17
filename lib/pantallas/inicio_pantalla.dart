import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../componentes/modal_evento.dart';
import '../componentes/tarjeta_evento_hoy.dart';
import '../componentes/tarjeta_progreso_dia.dart';
import '../controladores/proveedores.dart';
import '../entidades/evento.dart';
import '../entidades/pago.dart';
import '../utilidades/formato.dart';
import '../componentes/icono_categoria.dart';
import 'detalle_evento_pantalla.dart';

class InicioPantalla extends ConsumerWidget {
  const InicioPantalla({
    super.key,
    required this.alVerCalendario,
    required this.alVerPagos,
  });

  final VoidCallback alVerCalendario;
  final VoidCallback alVerPagos;

  bool _esMismoDia(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final hoy = DateTime.now();
    final usuario = ref.watch(usuarioProvider).valueOrNull;
    //final eventos = ref.watch(eventosProvider).valueOrNull ?? [];
    final eventosAsync = ref.watch(eventosProvider);
    final eventos = eventosAsync.valueOrNull ?? [];

    print('🔥 EVENTOS RAW: ${eventos.length}');
    for (final e in eventos) {
      print('➡️ ${e.titulo} - ${e.fechaHora} - completado: ${e.completado}');
    }

    final pagos = ref.watch(pagosProvider).valueOrNull ?? [];

    final eventosHoy =
        eventos.where((e) => _esMismoDia(e.fechaHora, hoy)).toList()
          ..sort((a, b) => a.fechaHora.compareTo(b.fechaHora));

    final proximos =
        eventos
            .where(
              (e) =>
                  !e.completado &&
                  e.fechaHora.isAfter(
                    DateTime(hoy.year, hoy.month, hoy.day, 23, 59, 59),
                  ),
            )
            .take(4)
            .toList();

    final completadosHoy = eventosHoy.where((e) => e.completado).length;
    final totalHoy = eventosHoy.length;
    final progreso = totalHoy == 0 ? 0.0 : completadosHoy / totalHoy;

    final pagosPendientes =
        pagos.where((p) => !p.pagado).toList()
          ..sort((a, b) => a.fechaVencimiento.compareTo(b.fechaVencimiento));
    final proximoPago =
        pagosPendientes.isNotEmpty ? pagosPendientes.first : null;

    final nombre = usuario?.nombre ?? 'Usuario';

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Formato.encabezadoSuperior(hoy),
                                  style: tema.textTheme.labelSmall?.copyWith(
                                    color: tema.colorScheme.onSurface
                                        .withValues(alpha: 0.45),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Hola, $nombre',
                                  style: tema.textTheme.headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tenés $totalHoy evento${totalHoy == 1 ? '' : 's'} hoy.',
                                  style: tema.textTheme.bodyMedium?.copyWith(
                                    color: tema.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const _BotonTema(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TarjetaProgresoDia(
                        completados: completadosHoy,
                        total: totalHoy,
                        progreso: progreso,
                      ),
                      const SizedBox(height: 24),
                      _encabezadoSeccion(
                        context,
                        'Hoy',
                        'Ver calendario',
                        alVerCalendario,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              if (eventosHoy.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'Sin eventos para hoy ✨',
                            style: tema.textTheme.bodyMedium?.copyWith(
                              color: tema.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TarjetaEventoHoy(
                        evento: eventosHoy[i],
                        alCompletar: () {},
                        alTocar: () => _abrirDetalle(context, eventosHoy[i]),
                      ),
                    ),
                    childCount: eventosHoy.length,
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Text(
                    'Próximos',
                    style: tema.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _ItemProximo(
                    evento: proximos[i],
                    alTocar:
                        () => mostrarModalEvento(
                          context,
                          eventoExistente: proximos[i],
                        ),
                  ),
                  childCount: proximos.length,
                ),
              ),
              if (proximoPago != null) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: _encabezadoSeccion(
                      context,
                      'Próximos pagos',
                      'Ver todos',
                      alVerPagos,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _TarjetaPagoResumen(pago: proximoPago),
                  ),
                ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarModalEvento(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _abrirDetalle(BuildContext context, Evento evento) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleEventoPantalla(eventoId: evento.id),
      ),
    );
  }

  Widget _encabezadoSeccion(
    BuildContext context,
    String titulo,
    String accion,
    VoidCallback alTocar,
  ) {
    return Row(
      children: [
        Text(
          titulo,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        TextButton(onPressed: alTocar, child: Text(accion)),
      ],
    );
  }
}

class _BotonTema extends ConsumerWidget {
  const _BotonTema();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oscuro = ref.watch(temaOscuroProvider);
    return IconButton.filledTonal(
      onPressed: () async {
        final nuevo = !oscuro;
        ref.read(temaOscuroProvider.notifier).state = nuevo;
        await ref.read(usuarioControladorProvider).actualizarTema(nuevo);
      },
      icon: Icon(oscuro ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
    );
  }
}

class _ItemProximo extends StatelessWidget {
  const _ItemProximo({required this.evento, required this.alTocar});

  final Evento evento;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        onTap: alTocar,
        leading: IconoCategoria(
          categoriaId: evento.categoriaId,
          iconoFallback: evento.icono,
        ),
        title: Text(
          evento.titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(Formato.proximoConHora(evento.fechaHora)),
        trailing: Icon(
          Icons.chevron_right,
          color: tema.colorScheme.onSurface.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}

class _TarjetaPagoResumen extends StatelessWidget {
  const _TarjetaPagoResumen({required this.pago});

  final Pago pago;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pago.titulo,
                    style: tema.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Vence ${Formato.fechaCorta(pago.fechaVencimiento)}',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              Formato.moneda(pago.monto),
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
