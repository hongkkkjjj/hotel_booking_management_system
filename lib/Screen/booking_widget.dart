import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/home_controller.dart';

class BookingScreen extends StatelessWidget {
  UserHomeController homeController = Get.find<UserHomeController>();

  BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              'Your trip',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
