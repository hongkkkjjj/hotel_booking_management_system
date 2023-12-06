import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/profile_controller.dart';

class UpdatePasswordScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update Password Screen'),
            // Add password update UI components here
          ],
        ),
      ),
    );
  }
}
