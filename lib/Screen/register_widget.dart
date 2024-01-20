import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Constant/app_const.dart';
import '../Controller/register_controller.dart';
import '../Widget/custom_elevated_button.dart';
import '../Widget/keyboard_dismiss_wrapper.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController registerController = Get.find<RegisterController>();
  final _formKey = GlobalKey<FormState>();

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
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        key: _formKey,
                        controller: registerController.nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        key: _formKey,
                        controller: registerController.emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        key: _formKey,
                        controller: registerController.mobileController,
                        decoration: const InputDecoration(
                            labelText: 'Mobile Number'),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        key: _formKey,
                        controller: registerController.passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Password'),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        key: _formKey,
                        controller: registerController
                            .confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                      ),
                      const SizedBox(height: 32.0),
                      CustomElevatedButton(
                        icon: Icons.person_add_alt_1,
                        label: 'Register',
                        backgroundColor: Colors.black54,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            registerController.createUserWithEmailAndPassword(context);
                          }
                        },
                      ),
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
}
