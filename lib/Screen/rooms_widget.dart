import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Constant/app_route.dart';
import 'package:hotel_booking_management_system/Screen/add_room_type_widget.dart';
import 'package:hotel_booking_management_system/Screen/adjust_room_price.dart';

import '../Constant/app_const.dart';
import '../Controller/rooms_controller.dart';
import '../Widget/custom_elevated_button.dart';

class RoomsScreen extends StatelessWidget {
  final RoomsController roomsController = Get.put(RoomsController(), permanent: true);

  RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Rooms'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: kWebWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  icon: Icons.add,
                  label: 'Add New Room Type',
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    Get.toNamed(Routes.addRooms);
                    // Get.bottomSheet(AddRoomTypeScreen(), isScrollControlled: true);
                  },
                ),
                const SizedBox(height: 16.0),
                CustomElevatedButton(
                  icon: Icons.money,
                  label: 'Adjust Room Price',
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    roomsController.addDummyRoomData();
                    Get.toNamed(Routes.adjustPrice);
                  },
                ),
                const SizedBox(height: 16.0),
                CustomElevatedButton(
                  icon: Icons.list,
                  label: 'Manage Rooms',
                  backgroundColor: Colors.indigo,
                  onPressed: () {
                    Get.toNamed(Routes.manageRoom);
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
