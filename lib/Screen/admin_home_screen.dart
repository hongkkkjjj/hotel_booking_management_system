import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Controller/landing_tab_controller.dart';

import '../Constant/app_route.dart';
import '../Controller/profile_controller.dart';
import '../Controller/trips_controller.dart';
import '../Structs/booking_data.dart';
import '../Structs/enums.dart';
import '../Utils/utils.dart';

class AdminHomeScreen extends StatelessWidget {
  TripsController tripsController = Get.find<TripsController>();
  LandingTabController landingTabController = Get.find<LandingTabController>();

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
                    onPressed: () async {
                      showLoaderDialog(context);
                      await tripsController.getTripsDataForAdmin();
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
            Obx(
              () => (tripsController.currentTrips.isNotEmpty)
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: tripsController.currentTrips.length,
                        itemBuilder: (context, index) {
                          BookingData selectedTrip =
                              tripsController.currentTrips[index];

                          return detailCard(selectedTrip, context, true);
                        },
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('No bookings for today'),
                    ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Chip(label: Text('Upcoming\'s bookings')),
            ),
            Obx(
              () => (tripsController.upcomingTrips.isNotEmpty)
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: tripsController.upcomingTrips.length,
                        itemBuilder: (context, index) {
                          BookingData selectedTrip =
                              tripsController.upcomingTrips[index];

                          return detailCard(selectedTrip, context, false);
                        },
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('No upcoming bookings'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailCard(
      BookingData selectedTrip, BuildContext context, bool isAllowLongPress) {
    BookingStatus status = mapIntToBookingStatus(selectedTrip.status);
    int guestCount = selectedTrip.guestCount;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () async {
          tripsController.selectedGuest.value = await landingTabController.retrieveUserData(selectedTrip.userId);
          tripsController.selectedTrips.value = selectedTrip;
          Get.toNamed(Routes.booking);
        },
        onLongPress: () {
          showBookingStatusMenu(context, selectedTrip);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  Text(
                    'Status: ${status.statusString}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const Text(
                'Last update by:',
                textAlign: TextAlign.end,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                selectedTrip.updateBy,
                textAlign: TextAlign.end,
              ),
              Text(
                Utils.formatDate(
                    selectedTrip.lastUpdate.toDate(), 'yyyy MMM dd'),
                textAlign: TextAlign.end,
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
        showLoaderDialog(context);
        String userName = Get.find<UserController>().name.value;
        bookingData.updateBy = userName;
        tripsController.updateTripStatus(
            context, bookingData, selectedStatus.index);
      }
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 16),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
