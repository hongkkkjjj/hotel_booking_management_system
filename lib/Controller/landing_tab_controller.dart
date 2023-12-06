import 'package:get/get.dart';

enum UserType { guest, admin }

class LandingTabController extends GetxController {
  Rx<UserType> userType = UserType.guest.obs;

  void setUserType(UserType type) {
    userType.value = type;
  }
}