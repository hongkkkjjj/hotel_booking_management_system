import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Constant/app_const.dart';
import '../Controller/register_controller.dart';
import '../Widget/custom_elevated_button.dart';
import '../Widget/keyboard_dismiss_wrapper.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController registerController = Get.put(RegisterController());

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    registerController.clearAllController();

    return KeyboardDismissWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Register'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: kWebWidth),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: registerController.nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: registerController.emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: registerController.mobileController,
                      decoration: const InputDecoration(labelText: 'Mobile Number'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: registerController.passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: registerController.confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Confirm Password'),
                    ),
                    const SizedBox(height: 32.0),
                    CustomElevatedButton(
                      icon: Icons.person_add_alt_1,
                      label: 'Register',
                      backgroundColor: Colors.black54,
                      onPressed: () => registerController.register(),
                    ),
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
