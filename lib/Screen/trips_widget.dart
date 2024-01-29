import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Constant/app_route.dart';
import 'package:hotel_booking_management_system/Controller/trips_controller.dart';
import 'package:hotel_booking_management_system/Structs/booking_data.dart';
import 'package:hotel_booking_management_system/Structs/enums.dart';
import 'package:hotel_booking_management_system/Utils/utils.dart';

class TripsScreen extends StatelessWidget {
  TripsController tripsController = Get.find<TripsController>();

  TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    tripsController.selectedTrips.value = null;
    tripsController.getTripsData();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Current Trips',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: Obx(
                () => ListView.builder(
                  itemCount: tripsController.currentTrips.length,
                  itemBuilder: (context, index) {
                    BookingData selectedTrip = tripsController.currentTrips[index];
                    BookingStatus status =
                        mapIntToBookingStatus(selectedTrip.status);
                    int guestCount = selectedTrip.guestCount;

                    return InkWell(
                      onTap: () {
                        tripsController.selectedTrips.value = selectedTrip;
                        Get.toNamed(Routes.booking);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Text(
                                  '${Utils.formatDate(selectedTrip.startDate.toDate(), 'yyyy MMM dd')} - ${Utils.formatDate(selectedTrip.endDate.toDate(), 'MMM dd')}'),
                              const SizedBox(width: 24),
                              Text(
                                  '$guestCount ${(guestCount > 1) ? 'Person' : 'Persons'}'),
                              const Spacer(),
                              Text('Status: ${status.statusString}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Past Trips',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: Obx(
                () => ListView.builder(
                  itemCount: tripsController.pastTrips.length,
                  itemBuilder: (context, index) {
                    var selectedTrip = tripsController.pastTrips[index];
                    BookingStatus status =
                        mapIntToBookingStatus(selectedTrip.status);
                    int guestCount = selectedTrip.guestCount;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text(
                                '${Utils.formatDate(selectedTrip.startDate.toDate(), 'yyyy MMM dd')} - ${Utils.formatDate(selectedTrip.endDate.toDate(), 'MMM dd')}'),
                            const SizedBox(width: 24),
                            Text(
                                '$guestCount ${(guestCount > 1) ? 'Person' : 'Persons'}'),
                            const Spacer(),
                            Text('Status: ${status.statusString}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
