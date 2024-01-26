import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Constant/app_route.dart';
import '../Controller/login_controller.dart';
import '../FirebaseController/auth.dart';

class LoadingScreen extends StatelessWidget {
  final LoginController loginController = Get.find<LoginController>();

  LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = Auth().currentUser;
    if (user != null) {
      loginController.retrieveUserData(context, user);
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        Get.offNamed(Routes.login);
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                strokeWidth: 10,
                color: Colors.teal,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Container(
                margin: const EdgeInsets.only(left: 7),
                child: const Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
