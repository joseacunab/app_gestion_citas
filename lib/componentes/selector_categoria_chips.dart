import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controladores/proveedores.dart';
import 'categoria_chip.dart';
import 'modal_crear_categoria.dart';

class SelectorCategoriaChips extends ConsumerWidget {
  const SelectorCategoriaChips({
    super.key,
    required this.seleccionadaId,
    required this.alSeleccionar,
  });

  final String? seleccionadaId;
  final ValueChanged<String> alSeleccionar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriasAsync = ref.watch(categoriasProvider);

    return categoriasAsync.when(
      data: (categorias) {
        if (categorias.isEmpty) {
          return const Text('No hay categorías disponibles.');
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...categorias.map((cat) {
              return CategoriaChip(
                categoria: cat,
                seleccionada: cat.id == seleccionadaId,
                onTap: () => alSeleccionar(cat.id),
              );
            }),
            CategoriaChipCrear(
              onTap: () async {
                final nuevaId = await mostrarModalCrearCategoria(context, ref);
                if (nuevaId != null) {
                  alSeleccionar(nuevaId);
                }
              },
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(minHeight: 2),
      ),
      error: (_, __) => const Text('Error al cargar categorías.'),
    );
  }
}
