import 'package:flutter/foundation.dart';
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
    tripsController.getTripsDataForUser();

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
            Obx(
              () => Expanded(
                child: ListView.builder(
                  itemCount: tripsController.currentTrips.length,
                  itemBuilder: (context, index) {
                    BookingData selectedTrip =
                        tripsController.currentTrips[index];
                            
                    return detailCard(selectedTrip);
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'Past Trips',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Obx(
              () => Expanded(
                child: ListView.builder(
                  itemCount: tripsController.pastTrips.length,
                  itemBuilder: (context, index) {
                    BookingData selectedTrip = tripsController.pastTrips[index];
                            
                    return detailCard(selectedTrip);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailCard(BookingData selectedTrip) {
    BookingStatus status = mapIntToBookingStatus(selectedTrip.status);
    int guestCount = selectedTrip.guestCount;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          tripsController.selectedTrips.value = selectedTrip;
          Get.toNamed(Routes.booking);
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
                    Text(
                        '${Utils.formatDate(selectedTrip.startDate.toDate(), 'yyyy MMM dd')} - ${Utils.formatDate(selectedTrip.endDate.toDate(), 'MMM dd')}'),
                  const SizedBox(width: 24),
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
}
