import 'package:firebase_auth/firebase_auth.dart';

class AuthServicio {
  AuthServicio({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Stream<User?> get cambiosUsuario => _auth.authStateChanges();

  User? get usuarioActual => _auth.currentUser;

  String? get usuarioId => _auth.currentUser?.uid;
  /*  Future<UserCredential> iniciarSesion({
    required String correo,
    required String contrasena,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena,
    );
  }*/
  Future<UserCredential> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    try {
      print("🔐 Intentando login con: $correo");

      final result = await _auth.signInWithEmailAndPassword(
        email: correo.trim(),
        password: contrasena,
      );

      print("✅ Login exitoso: ${result.user?.uid}");

      return result;
    } catch (e) {
      print("❌ Error login: $e");
      rethrow;
    }
  }

  Future<UserCredential> registrar({
    required String correo,
    required String contrasena,
    required String nombre,
    required String apellido,
  }) async {
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena,
    );
    return credencial;
  }

  Future<void> cerrarSesion() => _auth.signOut();
}
