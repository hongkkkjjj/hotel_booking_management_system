import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../FirebaseController/firestore_controller.dart';
import '../Structs/user_data.dart';

enum UserType { guest, admin }

class LandingTabController extends GetxController {
  Rx<UserType> userType = UserType.guest.obs;

  void setUserType(UserType type) {
    userType.value = type;
  }

  Future<UserData?> retrieveUserData(String userId) async {
    UserData? userData = await FirestoreController().getUserData(userId);

    if (userData != null) {
      return userData;
    } else {
      return null;
    }
  }
}