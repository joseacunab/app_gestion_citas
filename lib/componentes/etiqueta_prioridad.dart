import 'package:flutter/material.dart';

class EtiquetaPrioridad extends StatelessWidget {
  const EtiquetaPrioridad({super.key, required this.prioridad});

  final String prioridad;

  @override
  Widget build(BuildContext context) {
    final (color, etiqueta) = switch (prioridad.toLowerCase()) {
      'urgente' => (const Color(0xFFE53935), 'URGENTE'),
      'importante' => (const Color(0xFFFF9800), 'IMPORTANTE'),
      _ => (const Color(0xFF4A80F0), 'NORMAL'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            etiqueta,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
