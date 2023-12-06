import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Screen/landing_tab_widget.dart';
import '../Controller/login_controller.dart';
import 'register_widget.dart';

class LoginWidget extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginController.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: loginController.passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.lock_open, size: 24),
              onPressed: () {
                loginController.login();
              },
              label: const Text('Login'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.grey, // Adjust the color as needed
              ),
              icon: const Icon(Icons.person_add_alt_1),
              onPressed: () {
                // Navigate to the Register screen
                Get.to(RegisterScreen());
              },
              label: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
