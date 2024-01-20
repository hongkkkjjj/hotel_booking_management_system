import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Controller/profile_controller.dart';
import 'package:hotel_booking_management_system/FirebaseController/firestore_controller.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser =>_firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    var userController = Get.find<UserController>();
    authStateChanges.listen((User? user) {
      if (user!= null) {
        print(user.uid);
      }
    });
    // var ppl = currentUser.uid;
    // userController.
  }

  Future<void> createUserWithEmailAndPassword({required String email, required String password, required }) async {
    final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;

    if (user != null) {
      String uid = user.uid;
      FirestoreController().addUserData(userId, userData);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}