import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Constant/app_route.dart';
import 'package:hotel_booking_management_system/Controller/rooms_controller.dart';
import 'package:hotel_booking_management_system/FirebaseController/firestore_controller.dart';

class UserHomeController extends GetxController {
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().add(const Duration(days: 1)).obs;
  var guestCount = 1.obs;

  FirestoreController firestoreController = FirestoreController();

  void updateGuestCount(int newCount) {
    guestCount.value = newCount;
  }

  void updateStartDate(DateTime date) {
    startDate.value = date;
  }

  void updateEndDate(DateTime date) {
    endDate.value = date;
  }

  // Add a method for handling the search action
  void performSearch(BuildContext context) async {
    // Perform search logic here
    print('Searching: Start Date: ${startDate.value}, End Date: ${endDate.value}, Guest Count: ${guestCount.value}');

    DateTime formattedStartDate = DateTime(startDate.value.year, startDate.value.month, startDate.value.day, 23, 59, 59);
    DateTime formattedEndDate = DateTime(endDate.value.year, endDate.value.month, endDate.value.day);


    Set<String> resultSet = await firestoreController.getSearch(formattedStartDate, formattedEndDate);
    RoomsController roomsController = Get.find<RoomsController>();
    roomsController.searchRoomList = roomsController.roomList.where((room) => !resultSet.contains(room.id)).toList();
    roomsController.isSearch = true;

    roomsController.searchDuration = formattedEndDate.difference(formattedStartDate).inDays;

    print("wow day is ${roomsController.searchDuration}");
    print("wow roomlist length ${roomsController.searchRoomList.length}");

    if (roomsController.searchRoomList.isNotEmpty) {
      Get.toNamed(Routes.manageRoom);
    } else {
      _showUploadDialog(context, "No room found.", "All rooms within this period has fully booked!", () { });
    }
  }

  void _showUploadDialog(BuildContext context, String title, String content, VoidCallback? onDialogClose) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();

                if (onDialogClose != null) {
                  onDialogClose();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
