import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../componentes/modal_pago.dart';
import '../componentes/tarjeta_pago.dart';
import '../controladores/proveedores.dart';
import '../utilidades/formato.dart';

class PagosPantalla extends ConsumerWidget {
  const PagosPantalla({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final pagos = ref.watch(pagosProvider).valueOrNull ?? [];

    final pendientes = pagos.where((p) => !p.pagado).toList();
    final pagados = pagos.where((p) => p.pagado).toList();
    final totalPendiente =
        pendientes.fold<num>(0, (suma, p) => suma + p.monto);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pagos',
                      style: tema.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tus servicios, suscripciones y vencimientos.',
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: tema.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _ResumenCard(
                            etiqueta: 'Pendiente',
                            valor: Formato.moneda(totalPendiente),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ResumenCard(
                            etiqueta: 'Pagados',
                            valor: '${pagados.length}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Próximos vencimientos',
                      style: tema.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            if (pendientes.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: tema.colorScheme.onSurface.withValues(alpha: 0.15),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Text('Sin pagos pendientes 🎉'),
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
                    child: TarjetaPago(
                      pago: pendientes[i],
                      alEditar: () => mostrarModalPago(
                        context,
                        pagoExistente: pendientes[i],
                      ),
                    ),
                  ),
                  childCount: pendientes.length,
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                child: Text(
                  'Pagados',
                  style: tema.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TarjetaPago(
                    pago: pagados[i],
                    alEditar: () {},
                  ),
                ),
                childCount: pagados.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarModalPago(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ResumenCard extends StatelessWidget {
  const _ResumenCard({required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              etiqueta,
              style: tema.textTheme.bodySmall?.copyWith(
                color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              valor,
              style: tema.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
