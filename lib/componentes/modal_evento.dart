import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controladores/evento_controlador.dart';
import '../controladores/proveedores.dart';
import '../entidades/evento.dart';
import 'selector_categoria_chips.dart';

Future<void> mostrarModalEvento(
  BuildContext context, {
  Evento? eventoExistente,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => _ModalEventoContenido(eventoExistente: eventoExistente),
  );
}

class _ModalEventoContenido extends ConsumerStatefulWidget {
  const _ModalEventoContenido({this.eventoExistente});

  final Evento? eventoExistente;

  @override
  ConsumerState<_ModalEventoContenido> createState() =>
      _ModalEventoContenidoState();
}

class _ModalEventoContenidoState extends ConsumerState<_ModalEventoContenido> {
  late final TextEditingController _titulo;
  late final TextEditingController _ubicacion;
  late final TextEditingController _monto;
  late final TextEditingController _descripcion;
  late DateTime _fecha;
  late TimeOfDay _hora;
  late String? _categoriaId;
  late String _prioridad;
  late bool _recordatorio;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final e = widget.eventoExistente;
    _titulo = TextEditingController(text: e?.titulo ?? '');
    _ubicacion = TextEditingController(text: e?.ubicacion ?? '');
    _monto = TextEditingController(text: e?.monto.toString() ?? '0');
    _descripcion = TextEditingController(text: e?.descripcion ?? '');
    _fecha = e?.fechaHora ?? DateTime.now();
    _hora = e != null
        ? TimeOfDay.fromDateTime(e.fechaHora)
        : TimeOfDay.now();
    _categoriaId = e?.categoriaId;
    _prioridad = e?.prioridad ?? 'normal';
    _recordatorio = e?.recordatorio ?? true;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _ubicacion.dispose();
    _monto.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale: const Locale('es'),
    );
    if (elegida != null) setState(() => _fecha = elegida);
  }

  Future<void> _elegirHora() async {
    final elegida = await showTimePicker(context: context, initialTime: _hora);
    if (elegida != null) setState(() => _hora = elegida);
  }

  Future<void> _guardar() async {
    if (_titulo.text.trim().isEmpty || _categoriaId == null) return;
    setState(() => _guardando = true);

    final fechaHora = DateTime(
      _fecha.year,
      _fecha.month,
      _fecha.day,
      _hora.hour,
      _hora.minute,
    );

    final categorias = ref.read(categoriasProvider).valueOrNull ?? [];
    final cat = categorias.where((c) => c.id == _categoriaId).firstOrNull;
    final controlador = ref.read(eventoControladorProvider);

    try {
      await controlador.guardarDesdeFormulario(
        DatosFormularioEvento(
          eventoId: widget.eventoExistente?.id,
          titulo: _titulo.text,
          descripcion: _descripcion.text,
          fechaHora: fechaHora,
          ubicacion: _ubicacion.text,
          categoriaId: _categoriaId!,
          prioridad: _prioridad,
          recordatorio: _recordatorio,
          monto: num.tryParse(_monto.text) ?? 0,
          icono: cat?.icono ?? 'event',
          completado: widget.eventoExistente?.completado ?? false,
          completadoEn: widget.eventoExistente?.completadoEn,
          checklist: widget.eventoExistente?.checklist ?? const [],
        ),
      );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _eliminar() async {
    final evento = widget.eventoExistente;
    if (evento == null) return;
    await ref.read(eventoControladorProvider).eliminar(evento.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.eventoExistente != null;

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
                    esEdicion ? 'Editar evento' : 'Nuevo evento',
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
            _campo('Título', _titulo),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _botonFecha(
                    'Fecha',
                    '${_fecha.day.toString().padLeft(2, '0')}/'
                    '${_fecha.month.toString().padLeft(2, '0')}/'
                    '${_fecha.year}',
                    Icons.calendar_today_outlined,
                    _elegirFecha,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _botonFecha(
                    'Hora',
                    _hora.format(context),
                    Icons.access_time,
                    _elegirHora,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _campo('Ubicación', _ubicacion),
            const SizedBox(height: 12),
            _campo('Monto', _monto, teclado: TextInputType.number),
            const SizedBox(height: 16),
            Text(
              'Categoría',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            SelectorCategoriaChips(
              seleccionadaId: _categoriaId,
              alSeleccionar: (id) => setState(() => _categoriaId = id),
            ),
            const SizedBox(height: 16),
            Text('Prioridad', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'urgente', label: Text('Urgente')),
                ButtonSegment(value: 'importante', label: Text('Importante')),
                ButtonSegment(value: 'normal', label: Text('Normal')),
              ],
              selected: {_prioridad},
              onSelectionChanged: (s) =>
                  setState(() => _prioridad = s.first),
            ),
            const SizedBox(height: 12),
            _campo('Notas', _descripcion, maxLineas: 3),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Recordatorio'),
              value: _recordatorio,
              onChanged: (v) => setState(() => _recordatorio = v),
            ),
            const SizedBox(height: 20),
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

  Widget _campo(
    String etiqueta,
    TextEditingController controlador, {
    int maxLineas = 1,
    TextInputType? teclado,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        TextField(
          controller: controlador,
          maxLines: maxLineas,
          keyboardType: teclado,
        ),
      ],
    );
  }

  Widget _botonFecha(
    String etiqueta,
    String valor,
    IconData icono,
    VoidCallback alTocar,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        InkWell(
          onTap: alTocar,
          borderRadius: BorderRadius.circular(14),
          child: InputDecorator(
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
            ),
            child: Text(valor),
          ),
        ),
      ],
    );
  }
}
