import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../componentes/modal_nota.dart';
import '../componentes/tarjeta_nota.dart';
import '../controladores/proveedores.dart';

class NotasPantalla extends ConsumerWidget {
  const NotasPantalla({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final notas = ref.watch(notasProvider).valueOrNull ?? [];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notas',
                    style: tema.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ideas, recordatorios y pendientes rápidos.',
                    style: tema.textTheme.bodyMedium?.copyWith(
                      color: tema.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: notas.isEmpty
                  ? Center(
                      child: Text(
                        'Creá tu primera nota ✏️',
                        style: tema.textTheme.bodyMedium?.copyWith(
                          color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: notas.length,
                        itemBuilder: (_, i) => TarjetaNota(
                          nota: notas[i],
                          alTocar: () => mostrarModalNota(
                            context,
                            notaExistente: notas[i],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarModalNota(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
