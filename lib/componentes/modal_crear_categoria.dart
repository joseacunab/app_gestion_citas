import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controladores/categoria_controlador.dart';
import '../controladores/excepcion_controlador.dart';
import '../controladores/proveedores.dart';
import '../utilidades/iconos_categoria_catalogo.dart';
import '../utilidades/paleta_colores_categoria.dart';
import 'preview_categoria.dart';
import 'selector_color_categoria.dart';
import 'selector_icono_categoria.dart';

/// Abre el modal secundario "Nueva categoría" sobre el modal actual.
/// Devuelve el [id] de la categoría creada o `null` si se canceló.
Future<String?> mostrarModalCrearCategoria(
  BuildContext context,
  WidgetRef ref,
) {
  return showGeneralDialog<String?>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Nueva categoría',
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const _ModalCrearCategoriaContenido();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 4 * curved.value,
          sigmaY: 4 * curved.value,
        ),
        child: FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}

class _ModalCrearCategoriaContenido extends ConsumerStatefulWidget {
  const _ModalCrearCategoriaContenido();

  @override
  ConsumerState<_ModalCrearCategoriaContenido> createState() =>
      _ModalCrearCategoriaContenidoState();
}

class _ModalCrearCategoriaContenidoState
    extends ConsumerState<_ModalCrearCategoriaContenido> {
  final _nombre = TextEditingController();
  late String _color;
  late String _icono;
  bool _guardando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _color = PaletaColoresCategoria.porDefecto;
    _icono = IconosCategoriaCatalogo.porDefecto;
    _nombre.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  Future<void> _crear() async {
    setState(() {
      _guardando = true;
      _error = null;
    });

    try {
      final id = await ref.read(categoriaControladorProvider).crearCategoriaPersonalizada(
            DatosNuevaCategoria(
              nombre: _nombre.text,
              color: _color,
              icono: _icono,
            ),
          );
      if (mounted) Navigator.of(context).pop(id);
    } on ExcepcionControlador catch (e) {
      setState(() => _error = e.mensaje);
    } catch (_) {
      setState(() => _error = 'No se pudo crear la categoría.');
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          constraints: const BoxConstraints(maxWidth: 420, maxHeight: 640),
          decoration: BoxDecoration(
            color: tema.cardTheme.color ?? tema.colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Nueva categoría',
                        style: tema.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PreviewCategoria(
                        nombre: _nombre.text,
                        colorHex: _color,
                        icono: _icono,
                      ),
                      const SizedBox(height: 20),
                      Text('Nombre', style: tema.textTheme.labelLarge),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nombre,
                        maxLength: 25,
                        decoration: const InputDecoration(
                          hintText: 'Ej: Meditación',
                          counterText: '',
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectorColorCategoria(
                        seleccionado: _color,
                        onSeleccionar: (c) => setState(() => _color = c),
                      ),
                      const SizedBox(height: 20),
                      SelectorIconoCategoria(
                        seleccionado: _icono,
                        onSeleccionar: (i) => setState(() => _icono = i),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _guardando
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _guardando ? null : _crear,
                      child: _guardando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Crear'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
