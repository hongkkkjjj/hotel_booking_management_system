import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Widget/custom_elevated_button.dart';
import '../Constant/app_const.dart';
import '../Constant/app_route.dart';
import '../Controller/login_controller.dart';

class LoginWidget extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: kWebWidth),
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
                CustomElevatedButton(
                  icon: Icons.lock_open,
                  label: 'Login',
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    loginController.login();
                  },
                ),
                const SizedBox(height: 16.0),
                CustomElevatedButton(
                  icon: Icons.person_add_alt_1,
                  label: 'Register',
                  backgroundColor: Colors.black54,
                  onPressed: () {
                    Get.toNamed(Routes.register);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
