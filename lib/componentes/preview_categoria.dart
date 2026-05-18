import 'package:flutter/material.dart';

import '../utilidades/colores_util.dart';
import '../utilidades/iconos_util.dart';

class PreviewCategoria extends StatelessWidget {
  const PreviewCategoria({
    super.key,
    required this.nombre,
    required this.colorHex,
    required this.icono,
  });

  final String nombre;
  final String colorHex;
  final String icono;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final color = ColoresUtil.desdeHex(colorHex);
    final texto = nombre.trim().isEmpty ? 'Tu categoría' : nombre.trim();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tema.brightness == Brightness.dark
            ? const Color(0xFF252830)
            : const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: Icon(
                IconosUtil.desdeNombre(icono),
                key: ValueKey(icono),
                color: color,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    texto,
                    key: ValueKey(texto),
                    style: tema.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 280),
                  style: tema.textTheme.bodyMedium!.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  child: Text(colorHex.toUpperCase()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
