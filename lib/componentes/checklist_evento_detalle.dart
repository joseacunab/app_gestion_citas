import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controladores/proveedores.dart';
import '../entidades/evento.dart';
import '../entidades/item_checklist.dart';

/// Checklist interactiva en la pantalla de detalle del evento.
class ChecklistEventoDetalle extends ConsumerWidget {
  const ChecklistEventoDetalle({
    super.key,
    required this.evento,
  });

  final Evento evento;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final items = evento.checklist;
    if (items.isEmpty) return const SizedBox.shrink();

    final completados = items.where((i) => i.completado).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'CHECKLIST',
              style: tema.textTheme.labelSmall?.copyWith(
                color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
                letterSpacing: 1,
              ),
            ),
            const Spacer(),
            Text(
              '$completados/${items.length}',
              style: tema.textTheme.labelMedium,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...List.generate(items.length, (indice) {
          return _ItemChecklistDetalle(
            key: ValueKey('${evento.id}_check_$indice'),
            item: items[indice],
            onToggle: () => _alternar(ref, indice),
          );
        }),
      ],
    );
  }

  Future<void> _alternar(WidgetRef ref, int indice) async {
    final nuevaLista = evento.checklist.asMap().entries.map((entry) {
      if (entry.key == indice) {
        return entry.value.copiarCon(completado: !entry.value.completado);
      }
      return entry.value;
    }).toList();

    await ref.read(eventoControladorProvider).actualizarChecklist(
          evento.id,
          nuevaLista,
        );
  }
}

class _ItemChecklistDetalle extends StatefulWidget {
  const _ItemChecklistDetalle({
    super.key,
    required this.item,
    required this.onToggle,
  });

  final ItemChecklist item;
  final VoidCallback onToggle;

  @override
  State<_ItemChecklistDetalle> createState() => _ItemChecklistDetalleState();
}

class _ItemChecklistDetalleState extends State<_ItemChecklistDetalle> {
  bool _cargando = false;

  Future<void> _tocar() async {
    if (_cargando) return;
    setState(() => _cargando = true);
    await Future<void>.delayed(Duration.zero);
    widget.onToggle();
    if (mounted) setState(() => _cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final completado = widget.item.completado;
    final relleno = tema.brightness == Brightness.dark
        ? const Color(0xFF252830)
        : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: relleno,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: tema.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
        child: InkWell(
          onTap: _tocar,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: completado
                        ? const Color(0xFF4A80F0)
                        : Colors.transparent,
                    border: Border.all(
                      color: completado
                          ? const Color(0xFF4A80F0)
                          : tema.colorScheme.onSurface.withValues(alpha: 0.25),
                      width: 2,
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: completado
                        ? const Icon(
                            Icons.check,
                            key: ValueKey('check'),
                            size: 16,
                            color: Colors.white,
                          )
                        : const SizedBox(
                            key: ValueKey('empty'),
                            width: 26,
                            height: 26,
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    style: tema.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      decoration: completado
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: completado
                          ? tema.colorScheme.onSurface.withValues(alpha: 0.45)
                          : tema.colorScheme.onSurface,
                    ),
                    child: Text(widget.item.titulo),
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
