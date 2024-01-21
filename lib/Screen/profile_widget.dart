import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Constant/app_route.dart';

import '../Constant/app_const.dart';
import '../Controller/profile_controller.dart';
import '../Widget/custom_elevated_button.dart';

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
                Get.offAllNamed(Routes.login);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: kWebWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${userController.name}'),
                Text('Email: ${userController.email}'),
                Text('Mobile: ${userController.mobile}'),
                const SizedBox(height: 60.0),
                CustomElevatedButton(
                  icon: Icons.vpn_key,
                  label: 'Update Password',
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    Get.toNamed(Routes.updatePassword);
                  },
                ),
                const SizedBox(height: 16.0),
                CustomElevatedButton(
                  icon: Icons.add,
                  label: 'Add New Admin',
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    Get.toNamed(Routes.register, arguments: {'is_admin': true});
                  },
                ),
                const SizedBox(height: 16.0),
                CustomElevatedButton(
                  icon: Icons.logout,
                  label: 'Logout',
                  backgroundColor: Colors.red,
                  onPressed: () {
                    _showLogoutConfirmationDialog(context);
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
