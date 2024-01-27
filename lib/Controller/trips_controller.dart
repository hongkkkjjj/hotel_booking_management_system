import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Structs/booking_data.dart';
import 'package:hotel_booking_management_system/Structs/enums.dart';

import '../FirebaseController/auth.dart';
import '../FirebaseController/firestore_controller.dart';

class TripsController extends GetxController {
  List<BookingData> tripList = <BookingData>[].obs;
  RxList<BookingData> pastTrips = <BookingData>[].obs;
  RxList<BookingData> currentTrips = <BookingData>[].obs;

  FirestoreController firestoreController = FirestoreController();

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

        if (startDate.toDate().isAfter(now.toDate()) || endDate.toDate().isAfter(now.toDate())) {
          currentTrips.add(booking);
        } else {
          BookingStatus status = mapIntToBookingStatus(booking.status);
          if (status != BookingStatus.Completed || status != BookingStatus.Cancelled) {
            booking.status = BookingStatus.Cancelled.index;
          }
          pastTrips.add(booking);
        }
      }
    }
  }
}