import 'package:flutter/material.dart';

import '../entidades/evento.dart';
import '../utilidades/formato.dart';
import 'etiqueta_prioridad.dart';
import 'icono_categoria.dart';

class TarjetaEventoCalendario extends StatelessWidget {
  const TarjetaEventoCalendario({
    super.key,
    required this.evento,
    this.alTocar,
  });

  final Evento evento;
  final VoidCallback? alTocar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: alTocar,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconoCategoria(
                categoriaId: evento.categoriaId,
                iconoFallback: evento.icono,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      evento.titulo,
                      style: tema.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    EtiquetaPrioridad(prioridad: evento.prioridad),
                  ],
                ),
              ),
              Text(
                Formato.hora(evento.fechaHora),
                style: tema.textTheme.bodyMedium?.copyWith(
                  color: tema.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
