import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../FirebaseController/auth.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void register() {
    // Implement your registration logic here
    String name = nameController.text;
    String email = emailController.text;
    String mobile = mobileController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // For simplicity, just print the entered details
    print('Name: $name, Email: $email, Mobile: $mobile, Password: $password, Confirm Password: $confirmPassword');
  }

  Future<void> createUserWithEmailAndPassword(BuildContext context) async {
    try {
      await Auth().createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      Auth().currentUser
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
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
}
