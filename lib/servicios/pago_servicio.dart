import 'package:cloud_firestore/cloud_firestore.dart';

import '../entidades/pago.dart';

class PagoServicio {
  PagoServicio({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      _firestore.collection('pagos');

  Stream<List<Pago>> observarPagos(String usuarioId) {
    return _coleccion
        .where('usuarioId', isEqualTo: usuarioId)
        .snapshots()
        .map((snapshot) {
      final lista = <Pago>[];
      for (final doc in snapshot.docs) {
        try {
          lista.add(Pago.fromFirestore(doc.id, doc.data()));
        } catch (_) {
          // Documento con formato de fecha inválido; se omite.
        }
      }
      lista.sort((a, b) => a.fechaVencimiento.compareTo(b.fechaVencimiento));
      return lista;
    });
  }

  Future<String> crear(Pago pago) async {
    final ref = await _coleccion.add(pago.toMap());
    return ref.id;
  }

  Future<void> actualizar(String pagoId, Map<String, dynamic> datos) {
    return _coleccion.doc(pagoId).update(datos);
  }

  Future<void> eliminar(String pagoId) {
    return _coleccion.doc(pagoId).delete();
  }

  Future<void> marcarPagado(String pagoId, bool pagado) {
    return _coleccion.doc(pagoId).update({
      'pagado': pagado,
      'pagadoEn': pagado ? DateTime.now() : null,
    });
  }
}
