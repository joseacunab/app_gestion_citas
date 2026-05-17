import 'package:flutter/material.dart';

import '../entidades/nota.dart';
import '../utilidades/colores_util.dart';
import '../utilidades/formato.dart';

class TarjetaNota extends StatelessWidget {
  const TarjetaNota({
    super.key,
    required this.nota,
    required this.alTocar,
  });

  final Nota nota;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    final fondo = oscuro
        ? ColoresUtil.fondoOscuro(nota.colorPrincipal)
        : ColoresUtil.desdeHex(nota.colorFondo);
    final acento = ColoresUtil.desdeHex(nota.colorPrincipal);

    return GestureDetector(
      onTap: alTocar,
      child: Container(
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 5,
              decoration: BoxDecoration(
                color: acento,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                nota.texto,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
              ),
            ),
            Text(
              Formato.fechaNota(nota.fecha),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.45),
                    letterSpacing: 0.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
