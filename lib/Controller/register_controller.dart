import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
