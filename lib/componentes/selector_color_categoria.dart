import 'package:flutter/material.dart';

import '../utilidades/paleta_colores_categoria.dart';

class SelectorColorCategoria extends StatelessWidget {
  const SelectorColorCategoria({
    super.key,
    required this.seleccionado,
    required this.onSeleccionar,
  });

  final String seleccionado;
  final ValueChanged<String> onSeleccionar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: tema.textTheme.labelLarge),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: PaletaColoresCategoria.colores.map((hex) {
            final activo = hex == seleccionado;
            return _CirculoColor(
              hex: hex,
              activo: activo,
              onTap: () => onSeleccionar(hex),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: tema.brightness == Brightness.dark
                ? const Color(0xFF252830)
                : const Color(0xFFF0F2F5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            seleccionado.toUpperCase(),
            style: tema.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _CirculoColor extends StatefulWidget {
  const _CirculoColor({
    required this.hex,
    required this.activo,
    required this.onTap,
  });

  final String hex;
  final bool activo;
  final VoidCallback onTap;

  @override
  State<_CirculoColor> createState() => _CirculoColorState();
}

class _CirculoColorState extends State<_CirculoColor> {
  bool _presionado = false;

  Color get _color {
    final valor = widget.hex.replaceAll('#', '');
    return Color(int.parse('FF$valor', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) => setState(() => _presionado = false),
      onTapCancel: () => setState(() => _presionado = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: widget.activo ? 1.08 : (_presionado ? 0.92 : 1),
        duration: const Duration(milliseconds: 180),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _color,
            shape: BoxShape.circle,
            border: widget.activo
                ? Border.all(color: Colors.white, width: 2.5)
                : null,
            boxShadow: widget.activo
                ? [
                    BoxShadow(
                      color: _color.withValues(alpha: 0.45),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: widget.activo
                ? const Icon(
                    Icons.check,
                    key: ValueKey('check'),
                    color: Colors.white,
                    size: 18,
                  )
                : const SizedBox(key: ValueKey('empty'), width: 36, height: 36),
          ),
        ),
      ),
    );
  }
}
