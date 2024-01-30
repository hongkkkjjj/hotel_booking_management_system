import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constant/app_const.dart';
import '../Controller/profile_controller.dart';
import '../Widget/custom_elevated_button.dart';
import '../Widget/keyboard_dismiss_wrapper.dart';
import '../Widget/password_textfield.dart';

class UpdatePasswordScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();

  UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    userController.existingPassword.clear();
    userController.newPassword.clear();
    userController.confirmPassword.clear();

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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PasswordTextField(
                        controller: userController.existingPassword,
                        labelText: 'Existing Password',
                        validator: (value) {
                          if ((value?.length ?? 0) >= 6) {
                            return null;
                          }
                          return "Invalid password length";
                        },
                      ),
                      const SizedBox(height: 16),
                      PasswordTextField(
                        controller: userController.newPassword,
                        labelText: 'New Password',
                        validator: (value) {
                          if ((value?.length ?? 0) >= 6) {
                            return null;
                          }
                          return "Invalid password length";
                        },
                      ),
                      const SizedBox(height: 16),
                      PasswordTextField(
                        controller: userController.confirmPassword,
                        labelText: 'Confirm Password',
                        validator: (value) {
                          if ((value?.length ?? 0) < 6) {
                            return "Invalid password length";
                          } else if (value != userController.newPassword.text) {
                            return "Password are not same";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'You would need to login again after updating the password.',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomElevatedButton(
                        icon: Icons.check_circle,
                        label: 'Update',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showLoaderDialog(context);
                            userController.updatePassword();
                          }
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
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 16),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
