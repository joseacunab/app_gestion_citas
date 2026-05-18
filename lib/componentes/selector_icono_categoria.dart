import 'package:flutter/material.dart';

import '../utilidades/iconos_categoria_catalogo.dart';
import '../utilidades/iconos_util.dart';

class SelectorIconoCategoria extends StatelessWidget {
  const SelectorIconoCategoria({
    super.key,
    required this.seleccionado,
    required this.onSeleccionar,
  });

  final String seleccionado;
  final ValueChanged<String> onSeleccionar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final relleno = tema.brightness == Brightness.dark
        ? const Color(0xFF252830)
        : const Color(0xFFF0F2F5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ícono', style: tema.textTheme.labelLarge),
        const SizedBox(height: 10),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: relleno,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: IconosCategoriaCatalogo.nombres.length,
              itemBuilder: (context, i) {
                final nombre = IconosCategoriaCatalogo.nombres[i];
                return _CeldaIcono(
                  nombre: nombre,
                  seleccionado: nombre == seleccionado,
                  onTap: () => onSeleccionar(nombre),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CeldaIcono extends StatefulWidget {
  const _CeldaIcono({
    required this.nombre,
    required this.seleccionado,
    required this.onTap,
  });

  final String nombre;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  State<_CeldaIcono> createState() => _CeldaIconoState();
}

class _CeldaIconoState extends State<_CeldaIcono> {
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: widget.seleccionado
                ? const Color(0xFF4A80F0).withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            IconosUtil.desdeNombre(widget.nombre),
            color: widget.seleccionado
                ? const Color(0xFF4A80F0)
                : tema.colorScheme.onSurface.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}
