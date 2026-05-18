import 'package:flutter/material.dart';

import '../entidades/categoria.dart';
import '../utilidades/colores_util.dart';

class CategoriaChip extends StatefulWidget {
  const CategoriaChip({
    super.key,
    required this.categoria,
    required this.seleccionada,
    required this.onTap,
  });

  final Categoria categoria;
  final bool seleccionada;
  final VoidCallback onTap;

  @override
  State<CategoriaChip> createState() => _CategoriaChipState();
}

class _CategoriaChipState extends State<CategoriaChip> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final color = ColoresUtil.desdeHex(widget.categoria.color);
    final oscuro = tema.brightness == Brightness.dark;

    final fondo = widget.seleccionada
        ? color.withValues(alpha: oscuro ? 0.28 : 0.18)
        : (oscuro ? const Color(0xFF252830) : const Color(0xFFF0F2F5));

    final colorTexto = widget.seleccionada
        ? color
        : tema.colorScheme.onSurface.withValues(alpha: 0.75);

    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) => setState(() => _presionado = false),
      onTapCancel: () => setState(() => _presionado = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _presionado ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: fondo,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.seleccionada
                  ? color.withValues(alpha: 0.5)
                  : tema.colorScheme.onSurface.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
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
              const SizedBox(width: 8),
              Text(
                widget.categoria.nombre,
                style: tema.textTheme.bodyMedium?.copyWith(
                  fontWeight:
                      widget.seleccionada ? FontWeight.w600 : FontWeight.w500,
                  color: colorTexto,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriaChipCrear extends StatefulWidget {
  const CategoriaChipCrear({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<CategoriaChipCrear> createState() => _CategoriaChipCrearState();
}

class _CategoriaChipCrearState extends State<CategoriaChipCrear> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final borde = tema.colorScheme.onSurface.withValues(alpha: 0.2);

    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) => setState(() => _presionado = false),
      onTapCancel: () => setState(() => _presionado = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _presionado ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        child: CustomPaint(
          painter: _BordePunteadoPainter(color: borde, radius: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  size: 18,
                  color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
                ),
                const SizedBox(width: 6),
                Text(
                  'Crear categoría',
                  style: tema.textTheme.bodyMedium?.copyWith(
                    color: tema.colorScheme.onSurface.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BordePunteadoPainter extends CustomPainter {
  _BordePunteadoPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    canvas.drawPath(
      _puntear(path, 5, 4),
      paint,
    );
  }

  Path _puntear(Path source, double dash, double gap) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double dist = 0;
      while (dist < metric.length) {
        final len = (dist + dash < metric.length) ? dash : metric.length - dist;
        dest.addPath(metric.extractPath(dist, dist + len), Offset.zero);
        dist += dash + gap;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _BordePunteadoPainter old) =>
      old.color != color;
}
