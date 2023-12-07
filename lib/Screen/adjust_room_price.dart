import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Constant/app_const.dart';
import 'package:hotel_booking_management_system/Controller/rooms_controller.dart';
import 'package:hotel_booking_management_system/Widget/pricing_calendar.dart';

class AdjustRoomPriceScreen extends StatelessWidget {
  final RoomsController roomsController = Get.find<RoomsController>();

  AdjustRoomPriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime maxDate = today.add(const Duration(days: 2 * 30));

    return CalendarControllerProvider(
      controller: roomsController.eventController,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Adjust room price'),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: kWebWidth),
            child: PricingCalendar(maxDate: maxDate),
          ),
        ),
      ),
    );
  }
}
