import 'package:cloud_firestore/cloud_firestore.dart';

import '../entidades/nota.dart';

class NotaServicio {
  NotaServicio({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      _firestore.collection('notas');

  Stream<List<Nota>> observarNotas(String usuarioId) {
    return _coleccion
        .where('usuarioId', isEqualTo: usuarioId)
        .snapshots()
        .map((snapshot) {
      final lista = <Nota>[];
      for (final doc in snapshot.docs) {
        try {
          lista.add(Nota.fromFirestore(doc.id, doc.data()));
        } catch (_) {
          // Documento con formato de fecha inválido; se omite.
        }
      }
      lista.sort((a, b) => b.fecha.compareTo(a.fecha));
      return lista;
    });
  }

  Future<String> crear(Nota nota) async {
    final ref = await _coleccion.add(nota.toMap());
    return ref.id;
  }

  Future<void> actualizar(String notaId, Map<String, dynamic> datos) {
    return _coleccion.doc(notaId).update(datos);
  }

  Future<void> eliminar(String notaId) {
    return _coleccion.doc(notaId).delete();
  }
}
