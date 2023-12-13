import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/utils.dart';

class RoomsController extends GetxController {
  RxBool sizeType = true.obs;
  EventController eventController = EventController();
  List<CalendarEventData> eventList = <CalendarEventData>[].obs;

  void updateSizeTypeValue(bool newValue) {
    sizeType.value = newValue;
  }

  void addCalendarEvent(List<CalendarEventData> list) {
    eventList = list;
    eventController.addAll(list);
  }

  void showAdjustRoomPriceDialog(
      List<CalendarEventData<Object?>> events, DateTime selectedDate) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                Utils.formatDate(selectedDate, 'yyyy-MM-dd'),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Old Price'),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Text('RM 250'),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward, size: 30),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('New Price'),
                      Container(
                        width: 100, // Adjust the width as needed
                        child: const TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      // Add your save logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
