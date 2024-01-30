import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/FirebaseController/firestore_controller.dart';
import 'package:hotel_booking_management_system/Structs/user_data.dart';

import '../Constant/app_route.dart';
import '../FirebaseController/auth.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> createUserInAuthAndFirestore(BuildContext context, bool isAdmin) async {
    try {
      await Auth().createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      // final User? user = userCredential.user;
      var user = Auth().currentUser;
      if (user != null) {
        UserData userData = UserData(nameController.text, mobileController.text, isAdmin, user.email!);
        bool result = await FirestoreController().addUserData(user.uid, userData.toMap());

        if (result) {
          clearAllController();
          if (!context.mounted) return;
          _showUploadDialog(context, 'Account has successfully created', 'You may login with your account now.', () {
            Navigator.of(context).pop();
            Get.offNamed(Routes.login);
          });
        } else {
          if (!context.mounted) return;
          Navigator.of(context).pop();
          _showUploadDialog(context, '', 'Something wrong is happened. Please try again.', null);
        }

      } else {
        if (!context.mounted) return;
        Navigator.of(context).pop();
      }
    
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Oops: ${e.message}')),
      );
    }
  }

  void clearAllController()
  {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void _showUploadDialog(BuildContext context, String title, String content, VoidCallback? onDialogClose) {
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
