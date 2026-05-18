import 'package:flutter/material.dart';

import '../entidades/item_checklist.dart';

/// Editor de tareas para el modal de evento (estilo pills).
class ChecklistEditor extends StatefulWidget {
  const ChecklistEditor({
    super.key,
    required this.items,
    required this.onChanged,
  });

  final List<ItemChecklist> items;
  final ValueChanged<List<ItemChecklist>> onChanged;

  @override
  State<ChecklistEditor> createState() => _ChecklistEditorState();
}

class _ChecklistEditorState extends State<ChecklistEditor> {
  final _controladorTexto = TextEditingController();

  @override
  void dispose() {
    _controladorTexto.dispose();
    super.dispose();
  }

  void _agregarTarea() {
    final texto = _controladorTexto.text.trim();
    if (texto.isEmpty) return;

    widget.onChanged([
      ...widget.items,
      ItemChecklist(titulo: texto, completado: false),
    ]);
    _controladorTexto.clear();
  }

  void _eliminarTarea(int indice) {
    final nuevas = List<ItemChecklist>.from(widget.items)..removeAt(indice);
    widget.onChanged(nuevas);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final relleno = tema.brightness == Brightness.dark
        ? const Color(0xFF252830)
        : const Color(0xFFF0F2F5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Anotaciones / Tareas',
          style: tema.textTheme.labelLarge?.copyWith(
            color: tema.colorScheme.onSurface.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controladorTexto,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _agregarTarea(),
                decoration: InputDecoration(
                  hintText: 'Escribí una tarea y presioná Enter...',
                  filled: true,
                  fillColor: relleno,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(
                      color: tema.colorScheme.onSurface.withValues(alpha: 0.08),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(
                      color: Color(0xFF4A80F0),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _BotonAgregar(onPressed: _agregarTarea),
          ],
        ),
        if (widget.items.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...List.generate(widget.items.length, (indice) {
            return _FilaTareaAnimada(
              key: ValueKey('tarea_${indice}_${widget.items[indice].titulo}'),
              item: widget.items[indice],
              onEliminar: () => _eliminarTarea(indice),
            );
          }),
        ],
      ],
    );
  }
}

class _FilaTareaAnimada extends StatefulWidget {
  const _FilaTareaAnimada({
    super.key,
    required this.item,
    required this.onEliminar,
  });

  final ItemChecklist item;
  final VoidCallback onEliminar;

  @override
  State<_FilaTareaAnimada> createState() => _FilaTareaAnimadaState();
}

class _FilaTareaAnimadaState extends State<_FilaTareaAnimada>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrada;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _saliendo = false;

  @override
  void initState() {
    super.initState();
    _entrada = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _fade = CurvedAnimation(parent: _entrada, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entrada, curve: Curves.easeOutCubic));
    _entrada.forward();
  }

  @override
  void dispose() {
    _entrada.dispose();
    super.dispose();
  }

  Future<void> _eliminar() async {
    if (_saliendo) return;
    setState(() => _saliendo = true);
    await _entrada.reverse();
    widget.onEliminar();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final relleno = tema.brightness == Brightness.dark
        ? const Color(0xFF252830)
        : const Color(0xFFF0F2F5);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: SizeTransition(
          sizeFactor: _fade,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: relleno,
              shape: StadiumBorder(
                side: BorderSide(
                  color: tema.colorScheme.onSurface.withValues(alpha: 0.06),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          widget.item.titulo,
                          style: tema.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _eliminar,
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: tema.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BotonAgregar extends StatefulWidget {
  const _BotonAgregar({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_BotonAgregar> createState() => _BotonAgregarState();
}

class _BotonAgregarState extends State<_BotonAgregar> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) => setState(() => _presionado = false),
      onTapCancel: () => setState(() => _presionado = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _presionado ? 0.92 : 1,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: tema.colorScheme.onSurface.withValues(alpha: 0.06),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add,
            color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ),
    );
  }
}
