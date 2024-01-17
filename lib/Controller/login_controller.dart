import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Constant/app_route.dart';
import 'package:hotel_booking_management_system/FirebaseController/firestore_controller.dart';

import 'landing_tab_controller.dart';
import 'profile_controller.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FirestoreController firestoreController = FirestoreController();
  RxBool isAdmin = false.obs;

  void login() {
    // Implement your login logic here
    String username = emailController.text;
    String password = passwordController.text;

    // For simplicity, just print the entered username and password
    print('Username: $username, Password: $password');

    UserType userType = isAdmin.isTrue ? UserType.admin : UserType.guest;
    Get.find<LandingTabController>().setUserType(userType);

    Get.find<UserController>().updateUserDetails("Leonard da vinci", "test@gmail.com", "+60 123456789");

    // Navigate to the landing tab screen
    Get.offNamed(Routes.home);
  }

  Future<void> signIn() async {

  }
}