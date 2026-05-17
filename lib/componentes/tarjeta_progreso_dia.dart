import 'package:flutter/material.dart';

class TarjetaProgresoDia extends StatelessWidget {
  const TarjetaProgresoDia({
    super.key,
    required this.completados,
    required this.total,
    required this.progreso,
  });

  final int completados;
  final int total;
  final double progreso;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final porcentaje = (progreso * 100).round();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progreso del día',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: tema.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$completados/$total',
                    style: tema.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progreso),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      builder: (context, valor, _) {
                        return LinearProgressIndicator(
                          value: valor,
                          minHeight: 4,
                          backgroundColor:
                              tema.colorScheme.onSurface.withValues(alpha: 0.08),
                          color: const Color(0xFF4A80F0),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progreso),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, valor, _) {
                return SizedBox(
                  width: 72,
                  height: 72,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: valor,
                        strokeWidth: 5,
                        backgroundColor:
                            tema.colorScheme.onSurface.withValues(alpha: 0.08),
                        color: const Color(0xFF4A80F0),
                      ),
                      Text(
                        '$porcentaje%',
                        style: tema.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
