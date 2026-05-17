import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controladores/nota_controlador.dart';
import '../controladores/proveedores.dart';
import '../entidades/nota.dart';
import '../utilidades/colores_util.dart';

Future<void> mostrarModalNota(
  BuildContext context, {
  Nota? notaExistente,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => _ModalNotaContenido(notaExistente: notaExistente),
  );
}

class _PaletaNota {
  const _PaletaNota(this.principal, this.fondo);
  final String principal;
  final String fondo;
}

const _paletas = [
  _PaletaNota('#5B8DEF', '#E8F0FE'),
  _PaletaNota('#FF9F43', '#FFF3E6'),
  _PaletaNota('#E84393', '#FDE8F2'),
  _PaletaNota('#2ECC71', '#E8F8EF'),
  _PaletaNota('#9B59B6', '#F3EBFA'),
];

class _ModalNotaContenido extends ConsumerStatefulWidget {
  const _ModalNotaContenido({this.notaExistente});

  final Nota? notaExistente;

  @override
  ConsumerState<_ModalNotaContenido> createState() => _ModalNotaContenidoState();
}

class _ModalNotaContenidoState extends ConsumerState<_ModalNotaContenido> {
  late final TextEditingController _texto;
  late int _indiceColor;
  late DateTime _fecha;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final n = widget.notaExistente;
    _texto = TextEditingController(text: n?.texto ?? '');
    _fecha = n?.fecha ?? DateTime.now();
    _indiceColor = 0;
    if (n != null) {
      for (var i = 0; i < _paletas.length; i++) {
        if (_paletas[i].principal == n.colorPrincipal) {
          _indiceColor = i;
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_texto.text.trim().isEmpty) return;
    setState(() => _guardando = true);

    final paleta = _paletas[_indiceColor];
    final controlador = ref.read(notaControladorProvider);

    try {
      await controlador.guardarDesdeFormulario(
        DatosFormularioNota(
          notaId: widget.notaExistente?.id,
          texto: _texto.text,
          fecha: _fecha,
          icono: widget.notaExistente?.icono ?? 'lightbulb',
          colorPrincipal: paleta.principal,
          colorFondo: paleta.fondo,
        ),
      );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _eliminar() async {
    final nota = widget.notaExistente;
    if (nota == null) return;
    await ref.read(notaControladorProvider).eliminar(nota.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.notaExistente != null;
    final oscuro = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    esEdicion ? 'Editar nota' : 'Nueva nota',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _texto,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Escribí tu idea o recordatorio...',
              ),
            ),
            const SizedBox(height: 16),
            Text('Color', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_paletas.length, (i) {
                final color = ColoresUtil.desdeHex(_paletas[i].principal);
                final seleccionado = i == _indiceColor;
                return GestureDetector(
                  onTap: () => setState(() => _indiceColor = i),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: oscuro
                          ? ColoresUtil.fondoOscuro(_paletas[i].principal)
                          : ColoresUtil.desdeHex(_paletas[i].fondo),
                      shape: BoxShape.circle,
                      border: seleccionado
                          ? Border.all(color: color, width: 2.5)
                          : null,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                if (esEdicion)
                  TextButton(
                    onPressed: _eliminar,
                    child: const Text(
                      'Eliminar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _guardando ? null : _guardar,
                  child: Text(esEdicion ? 'Guardar' : 'Crear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
