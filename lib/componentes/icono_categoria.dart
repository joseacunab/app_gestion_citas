import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controladores/proveedores.dart';
import '../entidades/categoria.dart';
import '../utilidades/colores_util.dart';
import '../utilidades/iconos_util.dart';

class IconoCategoria extends ConsumerWidget {
  const IconoCategoria({
    super.key,
    required this.categoriaId,
    this.tamano = 40,
    this.iconoFallback,
  });

  final String categoriaId;
  final double tamano;
  final String? iconoFallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorias = ref.watch(categoriasProvider).valueOrNull ?? [];
    Categoria? cat;
    for (final c in categorias) {
      if (c.id == categoriaId) {
        cat = c;
        break;
      }
    }

    final color = cat != null
        ? ColoresUtil.desdeHex(cat.color)
        : Theme.of(context).colorScheme.primary;
    final icono = IconosUtil.desdeNombre(
      cat?.icono ?? iconoFallback ?? 'category',
    );

    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icono, color: color, size: tamano * 0.5),
    );
  }
}
