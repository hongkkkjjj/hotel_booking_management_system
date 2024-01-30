import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Constant/app_route.dart';

import '../Constant/app_const.dart';
import '../Controller/landing_tab_controller.dart';
import '../Controller/profile_controller.dart';
import '../Widget/custom_elevated_button.dart';

class ProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final LandingTabController landingTabController = Get.find<LandingTabController>();

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userController.name}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Email: ${userController.email}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          'Mobile: ${userController.mobile}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                CustomElevatedButton(
                  icon: Icons.vpn_key,
                  label: 'Update Password',
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    Get.toNamed(Routes.updatePassword);
                  },
                ),
                const SizedBox(height: 16.0),
                if (landingTabController.userType.value == UserType.admin)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CustomElevatedButton(
                      icon: Icons.person_add_alt_1,
                      label: 'Add New Admin',
                      backgroundColor: Colors.teal,
                      onPressed: () {
                        Get.toNamed(Routes.register, arguments: {'is_admin': true});
                      },
                    ),
                  ),
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
