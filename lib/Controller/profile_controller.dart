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
  final TextEditingController confirmPassword = TextEditingController();

  void updateUserDetails(String newName, String newEmail, String newMobile) {
    name.value = newName;
    email.value = newEmail;
    mobile.value = newMobile;
  }

  void updatePassword() async {
    bool result = await Auth().updatePassword(existingPassword.text, newPassword.text);
    if (result) {
      logout();
    }
  }

  void logout() async {
    await Auth().signOut();
    clearProfileController();
    Get.offAllNamed(Routes.login);
  }

  void clearProfileController() {
    name.value = '';
    email.value = '';
    mobile.value = '';
  }
}