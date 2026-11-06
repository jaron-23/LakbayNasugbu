
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // REGISTER NEW USER
  static Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final userCredential =
    await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = userCredential.user;

    if (user != null) {
      await user.updateDisplayName(name.trim());

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name.trim(),
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // SIGN IN EXISTING USER
  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final userCredential =
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = userCredential.user;

    if (user != null) {
      final userDoc =
      _firestore.collection('users').doc(user.uid);

      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  // SEND PASSWORD RESET EMAIL
  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }
}
