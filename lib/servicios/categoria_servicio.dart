import 'package:cloud_firestore/cloud_firestore.dart';

import '../entidades/categoria.dart';

class CategoriaServicio {
  CategoriaServicio({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      _firestore.collection('categorias');

  Stream<List<Categoria>> observarCategorias() {
    return _coleccion.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Categoria.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  Future<Categoria?> obtenerPorId(String categoriaId) async {
    final doc = await _coleccion.doc(categoriaId).get();
    if (!doc.exists || doc.data() == null) return null;
    return Categoria.fromFirestore(doc.id, doc.data()!);
  }
}
