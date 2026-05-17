import 'package:cloud_firestore/cloud_firestore.dart';

/// Conversión unificada Firestore ↔ [DateTime] (siempre [Timestamp] al guardar).
class FechasFirestore {
  FechasFirestore._();

  /// Lee un campo de fecha desde Firestore.
  /// Prioridad: [Timestamp] → [DateTime] → [String] legacy (migración).
  static DateTime desdeFirestore(dynamic valor) {
    if (valor == null) {
      throw FormatException('El campo de fecha es nulo.');
    }
    if (valor is Timestamp) return valor.toDate();
    if (valor is DateTime) return valor;
    if (valor is String && valor.isNotEmpty) {
      return DateTime.parse(valor);
    }
    throw FormatException(
      'Tipo de fecha no soportado: ${valor.runtimeType}',
    );
  }

  /// Igual que [desdeFirestore] pero admite `null`.
  static DateTime? desdeFirestoreNullable(dynamic valor) {
    if (valor == null) return null;
    return desdeFirestore(valor);
  }

  /// Normaliza a medianoche (campos solo-fecha: vencimiento, nota).
  static DateTime soloFecha(DateTime fecha) =>
      DateTime(fecha.year, fecha.month, fecha.day);
}
