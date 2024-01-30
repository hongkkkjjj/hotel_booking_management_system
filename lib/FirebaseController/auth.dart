import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    authStateChanges.listen((User? user) {
      if (user != null) {
        if (kDebugMode) {
          print(user.uid);
        }
      }
    });
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password, required}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> updatePassword(
      String existingPassword, String newPassword) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: existingPassword,
        );

        await currentUser.reauthenticateWithCredential(credential);
        await currentUser.updatePassword(newPassword);

        return true;
      }
    } catch (e) {
      print('Error updating password: $e');
    }
    return false;
  }
}
