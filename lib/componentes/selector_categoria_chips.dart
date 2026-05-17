import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controladores/proveedores.dart';
import '../utilidades/colores_util.dart';
import '../utilidades/iconos_util.dart';

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
    final categorias = ref.watch(categoriasProvider).valueOrNull ?? [];
    if (categorias.isEmpty) {
      return const Text('No hay categorías cargadas en Firestore.');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categorias.map((cat) {
        final seleccionada = cat.id == seleccionadaId;
        final color = ColoresUtil.desdeHex(cat.color);
        return FilterChip(
          selected: seleccionada,
          showCheckmark: false,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(cat.nombre),
            ],
          ),
          avatar: Icon(
            IconosUtil.desdeNombre(cat.icono),
            size: 16,
            color: color,
          ),
          selectedColor: color.withValues(alpha: 0.2),
          onSelected: (_) => alSeleccionar(cat.id),
        );
      }).toList(),
    );
  }
}
