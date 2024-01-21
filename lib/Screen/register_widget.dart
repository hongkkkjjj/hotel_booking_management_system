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

  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    var arg = Get.arguments;
    isAdmin = arg["is_admin"] ?? false;

    registerController.clearAllController();

    return KeyboardDismissWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text((isAdmin) ? 'Add new admin' : 'Register'),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: registerController.nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your name";
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: registerController.emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (GetUtils.isEmail((value ?? ""))) {
                            return null;
                          }
                          return "Please enter valid email";
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: registerController.mobileController,
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (GetUtils.isPhoneNumber(value ?? "")) {
                            return null;
                          }
                          return "Please enter valid phone number";
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: registerController.passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if ((value?.length ?? 0) >= 6) {
                            return null;
                          }
                          return "Invalid password length";
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller:
                            registerController.confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                        ),
                        validator: (value) {
                          if ((value?.length ?? 0) < 6) {
                            return "Invalid password length";
                          } else if (value != registerController.passwordController.text) {
                            return "Password are not same";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32.0),
                      CustomElevatedButton(
                        icon: Icons.person_add_alt_1,
                        label: 'Register',
                        backgroundColor: Colors.black54,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showLoaderDialog(context);
                            registerController
                                .createUserInAuthAndFirestore(context, isAdmin);
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

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 7),child:const Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}
