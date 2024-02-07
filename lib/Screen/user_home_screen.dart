import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Controller/home_controller.dart';
import 'package:hotel_booking_management_system/Controller/rooms_controller.dart';
import 'package:hotel_booking_management_system/Controller/trips_controller.dart';

class UserHomeScreen extends StatelessWidget {
  UserHomeController homeController = Get.find<UserHomeController>();
  RoomsController roomsController = Get.find<RoomsController>();

  UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    homeController.resetSearchOption();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            searchSection(context),
            const SizedBox(height: 32),
            buildFeatureRooms(),
          ],
        ),
      ),
    );
  }

  Widget searchSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 32.0 : 16.0),
      child: Card(
        color: Colors.teal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: kIsWeb ? buildWebLayout(context) : buildMobileLayout(context),
        ),
      ),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: homeController.startDate.value,
                    firstDate: DateTime.now().add(const Duration(days: 1)),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null &&
                      picked != homeController.startDate.value) {
                    homeController.updateStartDate(picked);
                  }
                },
                child: Obx(() => Text(
                    'From: ${homeController.startDate.value.toString().split(' ')[0]}')),
              ),
            ),

            // End Date
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: homeController.endDate.value,
                      firstDate: DateTime.now().add(const Duration(days: 2)),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null &&
                        picked != homeController.endDate.value) {
                      homeController.updateEndDate(picked);
                    }
                  },
                  child: Obx(() => Text(
                      'To: ${homeController.endDate.value.toString().split(' ')[0]}')),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Guest Count
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decrement Button
            ElevatedButton(
              onPressed: () {
                if (homeController.guestCount.value > 1) {
                  homeController
                      .updateGuestCount(homeController.guestCount.value - 1);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              child: const Icon(Icons.remove),
            ),

            // Guest Count Display
            Obx(() => ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.white,
                    disabledForegroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          4.0), // Matching the border radius of other buttons
                    ),
                  ),
                  child: Text(homeController.guestCount.value.toString()),
                )),

            // Increment Button
            ElevatedButton(
              onPressed: () {
                if (homeController.guestCount.value < 4) {
                  homeController
                      .updateGuestCount(homeController.guestCount.value + 1);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Search Button
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.find<TripsController>().selectedTrips.value = null;
                  homeController.selectedRoom.value = null;
                  homeController.performSearch(context);
                },
                child: const Text('Search'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildWebLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: homeController.startDate.value,
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (picked != null && picked != homeController.startDate.value) {
                homeController.updateStartDate(picked);
              }
            },
            child: Obx(() => Text(
                'From: ${homeController.startDate.value.toString().split(' ')[0]}')),
          ),
        ),

        // End Date
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: homeController.endDate.value,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != homeController.endDate.value) {
                  homeController.updateEndDate(picked);
                }
              },
              child: Obx(() => Text(
                  'To: ${homeController.endDate.value.toString().split(' ')[0]}')),
            ),
          ),
        ),

        // Guest Count
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decrement Button
              ElevatedButton(
                onPressed: () {
                  if (homeController.guestCount.value > 1) {
                    homeController
                        .updateGuestCount(homeController.guestCount.value - 1);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(Icons.remove),
              ),

              // Guest Count Display
              Obx(() => ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.white,
                      disabledForegroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            4.0), // Matching the border radius of other buttons
                      ),
                    ),
                    child: Text(homeController.guestCount.value.toString()),
                  )),

              // Increment Button
              ElevatedButton(
                onPressed: () {
                  if (homeController.guestCount.value < 4) {
                    homeController
                        .updateGuestCount(homeController.guestCount.value + 1);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),

        // Search Button
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Get.find<TripsController>().selectedTrips.value = null;
              homeController.selectedRoom.value = null;
              homeController.performSearch(context);
            },
            child: const Text('Search'),
          ),
        ),
      ],
    );
  }

  Widget buildFeatureRooms() {
    Widget roomCard(String imageUrl, String roomTitle, String price) {
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: SizedBox(
                width: kIsWeb ? 500 : 350,
                height: kIsWeb ? 250 : 175,
                child: (imageUrl.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) => const SizedBox(
                          width: 60,
                          height: 60,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Text(
                roomTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 32.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              'Explore Our Rooms',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          SizedBox(
            height: kIsWeb ? 400 : 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: min(roomsController.roomList.length, 5),
              itemBuilder: (context, index) {
                // Access room data at the current index
                var room = roomsController.roomList[index];
                var imageList =
                    roomsController.imageUrls[index.toString()] ?? [];
                String imageUrl = (imageList.isNotEmpty) ? imageList.first : '';

                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: roomCard(
                        imageUrl, room.title, 'RM${room.price.toString()}'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
