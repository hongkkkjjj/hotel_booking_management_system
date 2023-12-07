import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Screen/add_room_type_widget.dart';

import '../Controller/rooms_controller.dart';
import '../Widget/custom_elevated_button.dart';

class RoomsScreen extends StatelessWidget {
  final RoomsController roomsController = Get.put(RoomsController());

  RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomElevatedButton(
              icon: Icons.add,
              label: 'Add New Room Type',
              backgroundColor: Colors.teal,
              onPressed: () {
                Get.to(AddRoomTypeScreen());
                // Get.bottomSheet(AddRoomTypeScreen(), isScrollControlled: true);
              },
            ),
            const SizedBox(height: 16.0),
            CustomElevatedButton(
              icon: Icons.money,
              label: 'Adjust Room Price',
              backgroundColor: Colors.orange,
              onPressed: () {
                // Get.to(AdjustRoomPriceScreen());
              },
            ),
            const SizedBox(height: 16.0),
            CustomElevatedButton(
              icon: Icons.list,
              label: 'Manage Rooms',
              backgroundColor: Colors.indigo,
              onPressed: () {
                // Get.to(ManageRoomsScreen());
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
