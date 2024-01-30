import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constant/app_route.dart';
import '../Controller/trips_controller.dart';
import '../Structs/booking_data.dart';
import '../Structs/enums.dart';
import '../Utils/utils.dart';

class AdminHomeScreen extends StatelessWidget {
  TripsController tripsController = Get.find<TripsController>();

  AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    tripsController.getTripsDataForAdmin();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: kIsWeb ? 32 : 16,
          horizontal: kIsWeb ? 32 : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                children: [
                  const Chip(label: Text('Today\'s bookings')),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {

                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: kIsWeb ? 300 : 200,
              child: Obx(
                () => ListView.builder(
                  itemCount: tripsController.currentTrips.length,
                  itemBuilder: (context, index) {
                    BookingData selectedTrip =
                        tripsController.currentTrips[index];

                    return detailCard(selectedTrip, context, true);
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Chip(label: Text('Upcoming\'s bookings')),
            ),
            SizedBox(
              height: kIsWeb ? 300 : 200,
              child: Obx(
                () => ListView.builder(
                  itemCount: tripsController.upcomingTrips.length,
                  itemBuilder: (context, index) {
                    BookingData selectedTrip =
                        tripsController.upcomingTrips[index];

                    return detailCard(selectedTrip, context, false);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailCard(BookingData selectedTrip, BuildContext context, bool isAllowLongPress) {
    BookingStatus status = mapIntToBookingStatus(selectedTrip.status);
    int guestCount = selectedTrip.guestCount;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          tripsController.selectedTrips.value = selectedTrip;
          Get.toNamed(Routes.booking);
        },
        onLongPress: () {
          showBookingStatusMenu(context, selectedTrip);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!kIsWeb)
                Text(
                    '${Utils.formatDate(selectedTrip.startDate.toDate(), 'yyyy MMM dd')} - ${Utils.formatDate(selectedTrip.endDate.toDate(), 'MMM dd')}'),
              Row(
                children: [
                  if (kIsWeb)
                    Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: Text(
                          '${Utils.formatDate(selectedTrip.startDate.toDate(), 'yyyy MMM dd')} - ${Utils.formatDate(selectedTrip.endDate.toDate(), 'MMM dd')}'),
                    ),
                  Text(
                      '$guestCount ${(guestCount > 1) ? 'Person' : 'Persons'}'),
                  const Spacer(),
                  Text('Status: ${status.statusString}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showBookingStatusMenu(BuildContext context, BookingData bookingData) {
    showMenu<BookingStatus>(
      context: context,
      position: RelativeRect.fill,
      items: BookingStatus.values
          .map((status) => PopupMenuItem<BookingStatus>(
                value: status,
                child: Text(status.statusString),
              ))
          .toList(),
    ).then((selectedStatus) {
      if (selectedStatus != null) {
        tripsController.updateTripStatus(context, bookingData, selectedStatus.index);
      }
    });
  }
}
