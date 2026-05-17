import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../componentes/modal_evento.dart';
import '../componentes/tarjeta_evento_calendario.dart';
import '../controladores/proveedores.dart';
import '../entidades/evento.dart';
import '../utilidades/colores_util.dart';
import '../utilidades/formato.dart';
import 'detalle_evento_pantalla.dart';

class CalendarioPantalla extends ConsumerWidget {
  const CalendarioPantalla({super.key});

  bool _esMismoDia(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final mesFocus = ref.watch(fechaCalendarioProvider);
    final diaSeleccionado = ref.watch(diaSeleccionadoProvider);
    final eventos = ref.watch(eventosProvider).valueOrNull ?? [];
    final categorias = ref.watch(categoriasProvider).valueOrNull ?? [];

    final eventosDelDia = eventos
        .where((e) => _esMismoDia(e.fechaHora, diaSeleccionado))
        .toList()
      ..sort((a, b) => a.fechaHora.compareTo(b.fechaHora));

    final mapaEventos = <DateTime, List<Evento>>{};
    for (final e in eventos) {
      final clave = DateTime(e.fechaHora.year, e.fechaHora.month, e.fechaHora.day);
      mapaEventos.putIfAbsent(clave, () => []).add(e);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calendario',
                          style: tema.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Formato.mesAnio(mesFocus),
                          style: tema.textTheme.bodyMedium?.copyWith(
                            color: tema.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () {
                      ref.read(fechaCalendarioProvider.notifier).state =
                          DateTime(mesFocus.year, mesFocus.month - 1);
                    },
                    icon: const Icon(Icons.chevron_left),
                  ),
                  const SizedBox(width: 4),
                  IconButton.filledTonal(
                    onPressed: () {
                      ref.read(fechaCalendarioProvider.notifier).state =
                          DateTime(mesFocus.year, mesFocus.month + 1);
                    },
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TableCalendar<Evento>(
                    locale: 'es',
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2035),
                    focusedDay: mesFocus,
                    selectedDayPredicate: (day) =>
                        _esMismoDia(day, diaSeleccionado),
                    eventLoader: (day) {
                      final clave =
                          DateTime(day.year, day.month, day.day);
                      return mapaEventos[clave] ?? [];
                    },
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    headerVisible: false,
                    daysOfWeekHeight: 28,
                    onDaySelected: (sel, focus) {
                      ref.read(diaSeleccionadoProvider.notifier).state = sel;
                      ref.read(fechaCalendarioProvider.notifier).state = focus;
                    },
                    onPageChanged: (focus) {
                      ref.read(fechaCalendarioProvider.notifier).state = focus;
                    },
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: true,
                      todayDecoration: BoxDecoration(
                        color: const Color(0xFF4A80F0).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Color(0xFF4A80F0),
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: tema.textTheme.bodyMedium!,
                      defaultTextStyle: tema.textTheme.bodyMedium!,
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: tema.textTheme.labelSmall!.copyWith(
                        color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
                      ),
                      weekendStyle: tema.textTheme.labelSmall!.copyWith(
                        color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, eventosDia) {
                        if (eventosDia.isEmpty) return null;
                        return Positioned(
                          bottom: 4,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: eventosDia.take(3).map((ev) {
                              final cat = categorias
                                  .where((c) => c.id == ev.categoriaId)
                                  .firstOrNull;
                              final color = cat != null
                                  ? ColoresUtil.desdeHex(cat.color)
                                  : const Color(0xFF4A80F0);
                              return Container(
                                width: 5,
                                height: 5,
                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                Formato.encabezadoDia(diaSeleccionado),
                style: tema.textTheme.bodyMedium?.copyWith(
                  color: tema.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            Expanded(
              child: eventosDelDia.isEmpty
                  ? Center(
                      child: Text(
                        'Sin eventos este día',
                        style: tema.textTheme.bodyMedium?.copyWith(
                          color: tema.colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: eventosDelDia.length,
                      itemBuilder: (_, i) => TarjetaEventoCalendario(
                        evento: eventosDelDia[i],
                        alTocar: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetalleEventoPantalla(
                              eventoId: eventosDelDia[i].id,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarModalEvento(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
