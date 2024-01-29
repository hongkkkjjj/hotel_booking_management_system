import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Structs/booking_data.dart';
import 'package:hotel_booking_management_system/Utils/utils.dart';

import '../Constant/app_const.dart';
import '../Controller/home_controller.dart';
import '../Controller/profile_controller.dart';
import '../Controller/rooms_controller.dart';
import '../Controller/trips_controller.dart';
import '../FirebaseController/auth.dart';
import '../Widget/custom_elevated_button.dart';

class BookingScreen extends StatelessWidget {
  final RoomsController roomsController = Get.find<RoomsController>();
  final UserHomeController homeController = Get.find<UserHomeController>();
  final TripsController tripsController = Get.find<TripsController>();

  BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int roomSequence = homeController.roomSequence;
    List<String> selectedImgList =
        roomsController.imageUrls[roomSequence.toString()] ?? [];
    BookingData bookingData;

    if (tripsController.selectedTrips.value != null) {
      bookingData = tripsController.selectedTrips.value!;
    } else {
      DateTime formattedStartDate = DateTime(
          homeController.startDate.value.year,
          homeController.startDate.value.month,
          homeController.startDate.value.day,
          23,
          59,
          59);
      DateTime formattedEndDate = DateTime(homeController.endDate.value.year,
          homeController.endDate.value.month, homeController.endDate.value.day);
      User? user = Auth().currentUser;
      String userName = Get.find<UserController>().name.value;

      bookingData = BookingData(
        Timestamp.fromDate(formattedStartDate),
        Timestamp.fromDate(formattedEndDate),
        roomsController.searchRoomList[roomSequence].id,
        0,

        int.parse(roomsController.priceController.text) *
            roomsController.searchDuration,
        user?.uid ?? '',
        homeController.guestCount.value,
        userName,
        Timestamp.fromDate(DateTime.now()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: kWebWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your room',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Dates',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${Utils.formatTimestamp(bookingData.startDate, 'MMM dd')} - ${Utils.formatTimestamp(bookingData.endDate, 'MMM dd')}',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Guests',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${bookingData.guestCount} ${(bookingData.guestCount > 1) ? 'guests' : 'guest'}',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Divider(),
                  ),
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 96,
                                width: 96,
                                child: (selectedImgList.isNotEmpty)
                                    ? CachedNetworkImage(
                                  imageUrl: selectedImgList[0],
                                  placeholder: (context, url) =>
                                  const SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                        'assets/images/img_no_img.png',
                                        fit: BoxFit.fill,
                                      ),
                                  fit: BoxFit.fill,
                                )
                                    : Image.asset(
                                  'assets/images/img_no_img.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                roomsController.titleController.text,
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Divider(),
                          ),
                          const Text(
                            'Price details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'RM${roomsController.priceController.text} x ${roomsController.searchDuration} night.',
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'RM${int.parse(roomsController.priceController.text) * roomsController.searchDuration}',
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Divider(),
                  ),
                  const Text(
                    'Cancellation rules',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You can still cancel before ${Utils.formatTimestamp(bookingData.startDate, 'MMM dd')}.',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomElevatedButton(
                    label: 'Confirm',
                    backgroundColor: Colors.teal,
                    onPressed: () {
                      homeController.confirmBookingOrder(context, bookingData);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
