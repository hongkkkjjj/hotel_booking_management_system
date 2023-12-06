import 'package:get/get.dart';

class UserController extends GetxController {
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString mobile = ''.obs;

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

  void logout() {
    // Implement logout logic
    // For simplicity, this is a placeholder
    print('Logging out...');
  }
}