import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Controller/landing_tab_controller.dart';
import 'package:hotel_booking_management_system/Structs/booking_data.dart';
import 'package:hotel_booking_management_system/Structs/enums.dart';
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
  final LandingTabController landingTabController =
      Get.find<LandingTabController>();

  BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int roomSequence = homeController.roomSequence.value;
    List<String> selectedImgList =
        roomsController.imageUrls[roomSequence.toString()] ?? [];
    BookingData bookingData;
    String roomTitle;
    bool isAdmin = landingTabController.userType.value == UserType.admin;
    bool isNewBooking = tripsController.selectedTrips.value == null;

    if (!isNewBooking) {
      bookingData = tripsController.selectedTrips.value!;

      roomTitle = roomsController.roomList
          .firstWhere((room) => room.id == bookingData.roomId)
          .title;
    } else {
      DateTime formattedStartDate = DateTime(
        homeController.startDate.value.year,
        homeController.startDate.value.month,
        homeController.startDate.value.day,
      );
      DateTime formattedEndDate = DateTime(
        homeController.endDate.value.year,
        homeController.endDate.value.month,
        homeController.endDate.value.day,
        23,
        59,
        59,
      );
      User? user = Auth().currentUser;
      String userName = Get.find<UserController>().name.value;

      bookingData = BookingData(
        '',
        Timestamp.fromDate(formattedStartDate),
        Timestamp.fromDate(formattedEndDate),
        roomsController.searchRoomList[roomSequence].id,
        0,
        int.parse(roomsController.priceController.text),
        int.parse(roomsController.priceController.text) *
            roomsController.searchDuration,
        roomsController.searchDuration,
        user?.uid ?? '',
        homeController.guestCount.value,
        userName,
        Timestamp.fromDate(DateTime.now()),
      );
      roomTitle = roomsController.titleController.text;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text((isAdmin) ? 'Booking Details' : 'Confirmation'),
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
                  Text(
                    (isNewBooking) ? 'Your room' : 'Booking ID',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  if (!isNewBooking)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        bookingData.bookingId,
                        style: const TextStyle(fontWeight: FontWeight.w600),
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
                              Flexible(
                                child: Text(
                                  roomTitle,
                                  maxLines: null,
                                  style: const TextStyle(
                                    fontSize: 24,
                                  ),
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
                                'RM${bookingData.pricePerNight} x ${bookingData.duration} night.',
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'RM${bookingData.pricePerNight * bookingData.duration}',
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
                  cancelSection(bookingData, isAdmin, isNewBooking),
                  const SizedBox(height: 24),
                  guestDetail(isAdmin),
                  if (bookingData.status == 0 && !isAdmin)
                    CustomElevatedButton(
                      label: (isNewBooking) ? 'Confirm' : 'Cancel',
                      backgroundColor:
                          (isNewBooking) ? Colors.teal : Colors.red,
                      onPressed: () {
                        if (isNewBooking) {
                          homeController.confirmBookingOrder(
                              context, bookingData);
                        } else {
                          _showCancelConfirmationDialog(context, bookingData);
                        }
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

  Widget cancelSection(
      BookingData bookingData, bool isAdmin, bool isNewBooking) {
    if (bookingData.status != 0 && !isNewBooking || isAdmin) {
      return const SizedBox(height: 0);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      );
    }
  }

  Widget guestDetail(bool isAdmin) {
    if (isAdmin) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Divider(),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Name: '),
                      Flexible(
                        child: Text(
                          '${tripsController.selectedGuest.value?.username}',
                          textAlign: TextAlign.end,
                          maxLines: null,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mobile number: '),
                      Flexible(
                        child: Text(
                          '${tripsController.selectedGuest.value?.mobileNo}',
                          textAlign: TextAlign.end,
                          maxLines: null,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email: '),
                      Flexible(
                        child: Text(
                          '${tripsController.selectedGuest.value?.email}',
                          textAlign: TextAlign.end,
                          maxLines: null,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox(height: 0);
    }
  }

  Future<void> _showCancelConfirmationDialog(
      BuildContext context, BookingData bookingData) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel booking'),
          content: const Text('Are you sure you want to cancel this booking?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                String userName = Get.find<UserController>().name.value;
                bookingData.updateBy = userName;
                tripsController.updateTripStatus(
                    context, bookingData, BookingStatus.Cancelled.index);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
