import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Widget/custom_elevated_button.dart';
import '../Constant/app_const.dart';
import '../Constant/app_route.dart';
import '../Controller/login_controller.dart';

class LoginWidget extends StatelessWidget {
  final LoginController loginController = Get.find<LoginController>();
  final _formKey = GlobalKey<FormState>();

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
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: kWebWidth),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: loginController.emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (GetUtils.isEmail((value ?? ""))) {
                          return null;
                        }
                        return "Please enter valid email";
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: loginController.passwordController,
                      obscureText: true,
                      maxLength: 15,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        counterText: "",
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if ((value?.length ?? 0) >= 6) {
                          return null;
                        }
                        return "Invalid password length";
                      },
                    ),
                    const SizedBox(height: 32.0),
                    CustomElevatedButton(
                      icon: Icons.lock_open,
                      label: 'Login',
                      backgroundColor: Colors.teal,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showLoaderDialog(context);
                          loginController.signIn(context);
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    CustomElevatedButton(
                      icon: Icons.person_add_alt_1,
                      label: 'Register',
                      backgroundColor: Colors.black54,
                      onPressed: () {
                        Get.toNamed(Routes.register, arguments: {'is_admin': false});
                      },
                    ),
                    Obx(() => Switch(
                        value: loginController.isAdmin.value,
                        onChanged: (bool value) {
                          loginController.isAdmin.toggle();
                        })),
                  ],
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
