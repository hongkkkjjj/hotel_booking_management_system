import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Screen/login_widget.dart';
import 'package:hotel_booking_management_system/Screen/update_password_widget.dart';

import '../Controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  ProfileScreen({super.key});

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the logout method in UserController
                userController.logout();
                // Navigate back to the login screen
                Get.offAll(LoginWidget());
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${userController.name}'),
            Text('Email: ${userController.email}'),
            Text('Mobile: ${userController.mobile}'),
            const SizedBox(height: 60.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.vpn_key),
              onPressed: () {
                // Navigate to the update password screen
                Get.to(UpdatePasswordScreen());
              },
              label: const Text('Update Password'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.red,
              ),
              icon: const Icon(Icons.logout),
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
