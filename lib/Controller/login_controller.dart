import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Controller/profile_controller.dart';

import '../Screen/landing_tab_widget.dart';
import 'landing_tab_controller.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    // Implement your login logic here
    String username = emailController.text;
    String password = passwordController.text;

    // For simplicity, just print the entered username and password
    print('Username: $username, Password: $password');

    UserType userType = UserType.admin;
    Get.put(LandingTabController()).setUserType(userType);

    Get.put(UserController()).updateUserDetails("Leonard da vinci", "test@gmail.com", "+60 123456789");

    // Navigate to the landing tab screen
    Get.off(LandingTabScreen());
  }

  Future<void> signIn() async {
    // await FirebaseAuth
  }
}