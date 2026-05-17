import 'package:cloud_firestore/cloud_firestore.dart';

import '../entidades/usuario.dart';

class UsuarioServicio {
  UsuarioServicio({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      _firestore.collection('usuarios');

  Stream<Usuario?> observarUsuario(String usuarioId) {
    return _coleccion.doc(usuarioId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return Usuario.fromFirestore(doc.id, doc.data()!);
    });
  }

  Future<void> crearUsuario(String usuarioId, Usuario usuario) {
    return _coleccion.doc(usuarioId).set(usuario.toMap());
  }

  Future<void> actualizarUsuario(String usuarioId, Map<String, dynamic> datos) {
    return _coleccion.doc(usuarioId).update(datos);
  }
}
