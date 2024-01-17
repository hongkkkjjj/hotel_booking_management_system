import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Controller/home_controller.dart';
import 'package:hotel_booking_management_system/Controller/rooms_controller.dart';

import '../Constant/app_const.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserHomeController homeController = Get.find<UserHomeController>();
    final RoomsController roomsController = Get.find<RoomsController>();

    Widget buildWebLayout() {
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
                homeController.performSearch(context);
              },
              child: const Text('Search'),
            ),
          ),
        ],
      );
    }

    Widget buildMobileLayout() {
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
                      firstDate: DateTime.now(),
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
                        firstDate: DateTime.now(),
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
                    homeController.updateGuestCount(
                        homeController.guestCount.value - 1);
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
                    homeController.updateGuestCount(
                        homeController.guestCount.value + 1);
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

    Widget searchSection() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 32.0 : 16.0),
        child: Card(
          color: Colors.teal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: kIsWeb ? buildWebLayout() : buildMobileLayout(),
          ),
        ),
      );
    }

    Widget body() {
      return Column(
        children: [
          const SizedBox(height: 16),
          searchSection(),
          const SizedBox(height: 32),

        ],
      );
    }

    return Scaffold(
      body: body(),
    );
  }
}
