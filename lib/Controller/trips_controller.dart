import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Structs/booking_data.dart';
import 'package:hotel_booking_management_system/Structs/enums.dart';

import '../Constant/app_route.dart';
import '../FirebaseController/auth.dart';
import '../FirebaseController/firestore_controller.dart';

class TripsController extends GetxController {
  List<BookingData> tripList = <BookingData>[].obs;
  RxList<BookingData> pastTrips = <BookingData>[].obs;
  RxList<BookingData> currentTrips = <BookingData>[].obs;

  FirestoreController firestoreController = FirestoreController();

  Rx<BookingData?> selectedTrips = Rx<BookingData?>(null);

  void getTripsData() async {
    User? user = Auth().currentUser;
    if (user != null) {
      tripList = await firestoreController.getBookingDataForUser(user.uid);
      final dateNow = DateTime.now();
      final dateCheck = DateTime(dateNow.year, dateNow.month, dateNow.day);
      final now = Timestamp.fromDate(dateCheck); // Get the current timestamp
      currentTrips.clear();
      pastTrips.clear();

      for (final booking in tripList) {
        final startDate = booking.startDate;
        final endDate = booking.endDate;

        if (booking.status == BookingStatus.Cancelled.index ||
            booking.status == BookingStatus.Completed.index) {
          pastTrips.add(booking);
        } else if (startDate.toDate().isAfter(now.toDate()) ||
            endDate.toDate().isAfter(now.toDate())) {
          currentTrips.add(booking);
        } else {
          BookingStatus status = mapIntToBookingStatus(booking.status);
          if (status != BookingStatus.Completed ||
              status != BookingStatus.Cancelled) {
            booking.status = BookingStatus.Cancelled.index;
          }
          pastTrips.add(booking);
        }
      }
      update();
    }
  }

  void updateTripStatus(
      BuildContext context, BookingData bookingData, int status) async {
    bookingData.status = status;
    bool result = await firestoreController.updateBookingStatus(
        bookingData.bookingId, bookingData.toMap());

    if (result) {
      if (!context.mounted) return;

      BookingStatus status = mapIntToBookingStatus(bookingData.status);
      String msg;

      switch (status) {
        case BookingStatus.Cancelled:
          msg = 'Successfully cancelled the trips.';
          break;
        case BookingStatus.Completed:
          msg = 'The booking has been marked as completed.';
          break;
        case BookingStatus.CheckIn:
          msg = 'The guest has checked in.';
          break;
        case BookingStatus.Paid:
          msg = 'The booking has been marked as paid.';
          break;
        default:
          msg = '';
      }

      _showUploadDialog(context, 'Update Success', msg, () {
        getTripsData();
        Get.offAllNamed(Routes.home);
      });
    }
  }

  void _showUploadDialog(BuildContext context, String title, String content,
      VoidCallback? onDialogClose) {
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
