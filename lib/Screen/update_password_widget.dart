import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constant/app_const.dart';
import '../Controller/profile_controller.dart';
import '../Widget/custom_elevated_button.dart';
import '../Widget/keyboard_dismiss_wrapper.dart';
import '../Widget/password_textfield.dart';

class UpdatePasswordScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    userController.existingPassword.clear();
    userController.newPassword.clear();

    return KeyboardDismissWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Update Your Password'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: kWebWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PasswordTextField(
                      controller: userController.existingPassword,
                      labelText: 'Existing Password',
                    ),
                    const SizedBox(height: 16),
                    PasswordTextField(
                      controller: userController.newPassword,
                      labelText: 'New Password',
                    ),
                    const SizedBox(height: 24),
                    CustomElevatedButton(
                      icon: Icons.check_circle,
                      label: 'Update',
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    const SizedBox(height: 24.0),
                    // Add password update UI components here
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
