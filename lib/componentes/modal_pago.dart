import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controladores/pago_controlador.dart';
import '../controladores/proveedores.dart';
import '../entidades/pago.dart';
import 'selector_categoria_chips.dart';

Future<void> mostrarModalPago(
  BuildContext context, {
  Pago? pagoExistente,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => _ModalPagoContenido(pagoExistente: pagoExistente),
  );
}

class _ModalPagoContenido extends ConsumerStatefulWidget {
  const _ModalPagoContenido({this.pagoExistente});

  final Pago? pagoExistente;

  @override
  ConsumerState<_ModalPagoContenido> createState() => _ModalPagoContenidoState();
}

class _ModalPagoContenidoState extends ConsumerState<_ModalPagoContenido> {
  late final TextEditingController _titulo;
  late final TextEditingController _monto;
  late DateTime _vence;
  late String? _categoriaId;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final p = widget.pagoExistente;
    _titulo = TextEditingController(text: p?.titulo ?? '');
    _monto = TextEditingController(text: p?.monto.toString() ?? '');
    _vence = p?.fechaVencimiento ?? DateTime.now();
    _categoriaId = p?.categoriaId;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _monto.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: _vence,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale: const Locale('es'),
    );
    if (elegida != null) setState(() => _vence = elegida);
  }

  Future<void> _guardar() async {
    if (_titulo.text.trim().isEmpty || _categoriaId == null) return;
    setState(() => _guardando = true);

    final categorias = ref.read(categoriasProvider).valueOrNull ?? [];
    final cat = categorias.where((c) => c.id == _categoriaId).firstOrNull;
    final controlador = ref.read(pagoControladorProvider);

    try {
      await controlador.guardarDesdeFormulario(
        DatosFormularioPago(
          pagoId: widget.pagoExistente?.id,
          titulo: _titulo.text,
          monto: num.tryParse(_monto.text) ?? 0,
          fechaVencimiento: _vence,
          categoriaId: _categoriaId!,
          color: cat?.color ?? widget.pagoExistente?.color ?? '#4A80F0',
          pagado: widget.pagoExistente?.pagado ?? false,
          pagadoEn: widget.pagoExistente?.pagadoEn,
        ),
      );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.pagoExistente != null;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    esEdicion ? 'Editar pago' : 'Nuevo pago',
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
              controller: _titulo,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Internet, Spotify...',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _monto,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Monto'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _elegirFecha,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Vence',
                        suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                      ),
                      child: Text(
                        '${_vence.day.toString().padLeft(2, '0')}/'
                        '${_vence.month.toString().padLeft(2, '0')}/'
                        '${_vence.year}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Categoría', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SelectorCategoriaChips(
              seleccionadaId: _categoriaId,
              alSeleccionar: (id) => setState(() => _categoriaId = id),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
