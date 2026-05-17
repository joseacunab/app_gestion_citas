import 'package:cloud_firestore/cloud_firestore.dart';

import '../entidades/evento.dart';

class EventoServicio {
  EventoServicio({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      _firestore.collection('eventos');

  Stream<List<Evento>> observarEventos(String usuarioId) {
    return _coleccion.where('usuarioId', isEqualTo: usuarioId).snapshots().map((
      snapshot,
    ) {
      final lista = <Evento>[];
      for (final doc in snapshot.docs) {
        try {
          lista.add(Evento.fromFirestore(doc.id, doc.data()));
        } catch (_) {
          // Documento con formato de fecha inválido; se omite.
        }
      }
      lista.sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
      return lista;
    });
  }

  Future<Evento?> obtenerPorId(String eventoId) async {
    final doc = await _coleccion.doc(eventoId).get();
    if (!doc.exists || doc.data() == null) return null;
    return Evento.fromFirestore(doc.id, doc.data()!);
  }

  Future<String> crear(Evento evento) async {
    final ref = await _coleccion.add(evento.toMap());
    return ref.id;
  }

  Future<void> actualizar(String eventoId, Map<String, dynamic> datos) {
    return _coleccion.doc(eventoId).update(datos);
  }

  Future<void> eliminar(String eventoId) {
    return _coleccion.doc(eventoId).delete();
  }

  Future<void> marcarCompletado(String eventoId, bool completado) {
    return _coleccion.doc(eventoId).update({
      'completado': completado,
      'completadoEn': completado ? DateTime.now() : null,
    });
  }
}
