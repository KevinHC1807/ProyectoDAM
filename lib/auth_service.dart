import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// REGISTRO
  /// Devuelve `null` si todo salió bien, o un mensaje de error si falló.
  Future<String?> register({
    required String name,
    required String email,
    required int age,
    required String password,
  }) async {
    try {
      // 1. Crear usuario en Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      // 2. Guardar info extra en Firestore
      await _db.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'age': age,
        'role': 'user', // por si luego manejamos admin
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // null = todo OK
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error desconocido: $e';
    }
  }

  /// LOGIN
  /// Devuelve `null` si todo salió bien, o un mensaje de error si falló.
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error desconocido: $e';
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
}
