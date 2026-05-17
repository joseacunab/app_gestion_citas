import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controladores/proveedores.dart';
import '../entidades/evento.dart';
import '../utilidades/formato.dart';
import 'etiqueta_prioridad.dart';
import 'icono_categoria.dart';

class TarjetaEventoHoy extends ConsumerWidget {
  const TarjetaEventoHoy({
    super.key,
    required this.evento,
    required this.alCompletar,
    this.alTocar,
  });

  final Evento evento;
  final VoidCallback alCompletar;
  final VoidCallback? alTocar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final controlador = ref.read(eventoControladorProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: alTocar,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  await controlador.marcarCompletado(
                    evento.id,
                    !evento.completado,
                  );
                  alCompletar();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: evento.completado
                          ? const Color(0xFF4A80F0)
                          : tema.colorScheme.onSurface.withValues(alpha: 0.25),
                      width: 2,
                    ),
                    color: evento.completado
                        ? const Color(0xFF4A80F0)
                        : Colors.transparent,
                  ),
                  child: evento.completado
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            evento.titulo,
                            style: tema.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              decoration: evento.completado
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        Text(
                          Formato.hora(evento.fechaHora),
                          style: tema.textTheme.bodyMedium?.copyWith(
                            color: tema.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        IconoCategoria(
                          categoriaId: evento.categoriaId,
                          tamano: 22,
                          iconoFallback: evento.icono,
                        ),
                        EtiquetaPrioridad(prioridad: evento.prioridad),
                        if (evento.ubicacion.isNotEmpty) ...[
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: tema.colorScheme.onSurface
                                .withValues(alpha: 0.45),
                          ),
                          Text(
                            evento.ubicacion,
                            style: tema.textTheme.bodySmall?.copyWith(
                              color: tema.colorScheme.onSurface
                                  .withValues(alpha: 0.45),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (evento.recordatorio)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 14,
                                color: tema.colorScheme.onSurface
                                    .withValues(alpha: 0.45),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '2h',
                                style: tema.textTheme.bodySmall?.copyWith(
                                  color: tema.colorScheme.onSurface
                                      .withValues(alpha: 0.45),
                                ),
                              ),
                            ],
                          ),
                      ],
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
