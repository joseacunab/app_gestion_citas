import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controladores/proveedores.dart';
import '../entidades/pago.dart';
import '../utilidades/colores_util.dart';
import '../utilidades/formato.dart';

class TarjetaPago extends ConsumerWidget {
  const TarjetaPago({
    super.key,
    required this.pago,
    required this.alEditar,
  });

  final Pago pago;
  final VoidCallback alEditar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final controlador = ref.read(pagoControladorProvider);
    final color = ColoresUtil.desdeHex(pago.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => controlador.marcarPagado(pago.id, !pago.pagado),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: pago.pagado ? const Color(0xFF4A80F0) : Colors.transparent,
                  border: Border.all(
                    color: pago.pagado
                        ? const Color(0xFF4A80F0)
                        : tema.colorScheme.onSurface.withValues(alpha: 0.25),
                    width: 2,
                  ),
                ),
                child: pago.pagado
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pago.titulo,
                    style: tema.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration:
                          pago.pagado ? TextDecoration.lineThrough : null,
                      color: pago.pagado
                          ? tema.colorScheme.onSurface.withValues(alpha: 0.45)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pago.pagado
                        ? Formato.fechaCorta(
                            pago.pagadoEn ?? pago.fechaVencimiento,
                          )
                        : Formato.estadoVencimiento(pago.fechaVencimiento),
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formato.moneda(pago.monto),
                  style: tema.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration:
                        pago.pagado ? TextDecoration.lineThrough : null,
                    color: pago.pagado
                        ? tema.colorScheme.onSurface.withValues(alpha: 0.45)
                        : null,
                  ),
                ),
                if (!pago.pagado)
                  TextButton.icon(
                    onPressed: alEditar,
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: tema.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    label: Text(
                      'editar',
                      style: tema.textTheme.labelSmall?.copyWith(
                        color:
                            tema.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
