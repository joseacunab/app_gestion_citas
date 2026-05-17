import 'package:flutter/material.dart';

class BarraNavegacion extends StatelessWidget {
  const BarraNavegacion({
    super.key,
    required this.indiceActual,
    required this.alSeleccionar,
  });

  final int indiceActual;
  final ValueChanged<int> alSeleccionar;

  static const _items = [
    (Icons.home_outlined, Icons.home, 'Inicio'),
    (Icons.calendar_today_outlined, Icons.calendar_today, 'Calendario'),
    (Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, 'Pagos'),
    (Icons.description_outlined, Icons.description, 'Notas'),
    (Icons.person_outline, Icons.person, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final oscuro = tema.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: tema.cardTheme.color ?? tema.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: oscuro
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.grey.shade200,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final activo = i == indiceActual;
              final item = _items[i];
              return InkWell(
                onTap: () => alSeleccionar(i),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: activo
                            ? BoxDecoration(
                                color: const Color(0xFF4A80F0)
                                    .withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: Icon(
                          activo ? item.$2 : item.$1,
                          size: 22,
                          color: activo
                              ? const Color(0xFF4A80F0)
                              : tema.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.$3,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              activo ? FontWeight.w600 : FontWeight.w400,
                          color: activo
                              ? const Color(0xFF4A80F0)
                              : tema.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
