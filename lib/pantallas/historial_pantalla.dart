import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../componentes/barra_navegacion.dart';
import '../componentes/icono_categoria.dart';
import '../controladores/proveedores.dart';
import '../utilidades/formato.dart';

class HistorialPantalla extends ConsumerWidget {
  const HistorialPantalla({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final eventos = ref.watch(eventosProvider).valueOrNull ?? [];
    final pagos = ref.watch(pagosProvider).valueOrNull ?? [];

    final eventosPasados = eventos.where((e) => e.completado).toList();
    final pagosRealizados = pagos.where((p) => p.pagado).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Historial',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Eventos pasados',
            style: tema.textTheme.titleSmall?.copyWith(
              color: tema.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          if (eventosPasados.isEmpty)
            const Text('Sin eventos completados')
          else
            ...eventosPasados.map(
              (e) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: IconoCategoria(
                    categoriaId: e.categoriaId,
                    iconoFallback: e.icono,
                  ),
                  title: Text(
                    e.titulo,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(Formato.fechaCorta(e.fechaHora)),
                  trailing: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A80F0).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFF4A80F0),
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 28),
          Text(
            'Pagos realizados',
            style: tema.textTheme.titleSmall?.copyWith(
              color: tema.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          ...pagosRealizados.map(
            (p) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.titulo,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            Formato.fechaCorta(
                              p.pagadoEn ?? p.fechaVencimiento,
                            ),
                            style: tema.textTheme.bodySmall?.copyWith(
                              color: tema.colorScheme.onSurface
                                  .withValues(alpha: 0.45),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      Formato.moneda(p.monto),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarraNavegacion(
        indiceActual: 4,
        alSeleccionar: (_) => Navigator.popUntil(context, (r) => r.isFirst),
      ),
    );
  }
}
