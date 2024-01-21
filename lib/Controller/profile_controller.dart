import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Constant/app_route.dart';
import '../FirebaseController/auth.dart';

class UserController extends GetxController {
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString mobile = ''.obs;

  final TextEditingController existingPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();

  void updateUserDetails(String newName, String newEmail, String newMobile) {
    name.value = newName;
    email.value = newEmail;
    mobile.value = newMobile;
  }

  void updatePassword() {
    // Implement password update logic
    // For simplicity, this is a placeholder
    print('Updating password...');
  }

  void logout() async {
    print('Logging out...');
    await Auth().signOut();
    Get.offAllNamed(Routes.login);
  }
}