import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Constant/app_route.dart';
import 'package:hotel_booking_management_system/FirebaseController/firestore_controller.dart';
import 'package:hotel_booking_management_system/Structs/user_data.dart';

import '../FirebaseController/auth.dart';
import 'landing_tab_controller.dart';
import 'profile_controller.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FirestoreController firestoreController = FirestoreController();
  RxBool isAdmin = false.obs;

  Future<void> signIn(BuildContext context) async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      var user = Auth().currentUser;
      if (user != null) {
        UserData? userData = await FirestoreController().getUserData(user.uid);

        if (userData != null) {
          clearAllController();
          Get.find<LandingTabController>().setUserType(
              (userData.isAdmin) ? UserType.admin : UserType.guest);
          Get.find<UserController>().updateUserDetails(
              userData.username, user.email ?? "-", userData.mobileNo);
          if (!context.mounted) return;
          Navigator.of(context).pop();
          Get.toNamed(Routes.home);
        } else {
          if (!context.mounted) return;
          Navigator.of(context).pop();
          _showUploadDialog(context, '',
              'Something wrong is happened. Please try again.', null);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Oops: ${e.message}')),
      );
    }
  }

  void clearAllController() {
    emailController.text = '';
    passwordController.text = '';
  }

  void _showUploadDialog(BuildContext context, String title, String content,
      VoidCallback? onDialogClose) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (onDialogClose != null) {
                  onDialogClose();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
