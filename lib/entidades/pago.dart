import '../utilidades/fechas_firestore.dart';

class Pago {
  const Pago({
    required this.id,
    required this.usuarioId,
    required this.titulo,
    required this.monto,
    required this.fechaVencimiento,
    required this.categoriaId,
    required this.pagado,
    required this.pagadoEn,
    required this.color,
  });

  final String id;
  final String usuarioId;
  final String titulo;
  final num monto;
  final DateTime fechaVencimiento;
  final String categoriaId;
  final bool pagado;
  final DateTime? pagadoEn;
  final String color;

  factory Pago.fromFirestore(String id, Map<String, dynamic> datos) {
    return Pago(
      id: id,
      usuarioId: datos['usuarioId'] as String? ?? '',
      titulo: datos['titulo'] as String? ?? '',
      monto: datos['monto'] as num? ?? 0,
      fechaVencimiento: FechasFirestore.soloFecha(
        FechasFirestore.desdeFirestore(datos['fechaVencimiento']),
      ),
      categoriaId: datos['categoriaId'] as String? ?? '',
      pagado: datos['pagado'] as bool? ?? false,
      pagadoEn: FechasFirestore.desdeFirestoreNullable(datos['pagadoEn']),
      color: datos['color'] as String? ?? '#4A80F0',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'titulo': titulo,
      'monto': monto,
      'fechaVencimiento': FechasFirestore.soloFecha(fechaVencimiento),
      'categoriaId': categoriaId,
      'pagado': pagado,
      'pagadoEn': pagadoEn,
      'color': color,
    };
  }

  Pago copiarCon({
    String? titulo,
    num? monto,
    DateTime? fechaVencimiento,
    String? categoriaId,
    bool? pagado,
    DateTime? pagadoEn,
    String? color,
  }) {
    return Pago(
      id: id,
      usuarioId: usuarioId,
      titulo: titulo ?? this.titulo,
      monto: monto ?? this.monto,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      categoriaId: categoriaId ?? this.categoriaId,
      pagado: pagado ?? this.pagado,
      pagadoEn: pagadoEn,
      color: color ?? this.color,
    );
  }
}
