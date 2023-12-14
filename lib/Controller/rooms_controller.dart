import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constant/app_const.dart';
import '../FirebaseController/firestore_controller.dart';
import '../Structs/room_data.dart';
import '../Utils/utils.dart';

class RoomsController extends GetxController {
  RxBool sizeType = true.obs;
  EventController eventController = EventController();
  List<CalendarEventData> eventList = <CalendarEventData>[].obs;
  List<RoomData> roomList = <RoomData>[].obs;
  List<BedType> bedTypes = <BedType>[].obs;

  FirestoreController firestoreController = FirestoreController();

  @override
  void onInit() {
    super.onInit();
    getBedData();
  }

  void getBedData() async {
    List<BedType> bedTypes = await firestoreController.getBedData();
    for (var bed in bedTypes) {
      print('Bed ID: ${bed.id}, Bed Name: ${bed.bedName}');
    }
  }

  void updateSizeTypeValue(bool newValue) {
    sizeType.value = newValue;
  }

  void addCalendarEvent(List<CalendarEventData> list) {
    eventList = list;
    eventController.addAll(list);
  }

  void addDummyRoomData() {
    final dummyList =  [
      RoomData(1, 201, DateTime(2023, 12, 10)),
      RoomData(1, 199, DateTime(2023, 12, 11)),
      RoomData(2, 250, DateTime(2023, 12, 11)),
      RoomData(1, 201, DateTime(2023, 12, 12)),
      RoomData(1, 201, DateTime(2023, 12, 13)),
      RoomData(1, 201, DateTime(2023, 12, 14)),
      RoomData(1, 201, DateTime(2023, 12, 15)),
      RoomData(1, 201, DateTime(2023, 12, 16)),
      RoomData(1, 201, DateTime(2023, 12, 17)),
      RoomData(1, 201, DateTime(2023, 12, 18)),
      RoomData(1, 198, DateTime(2023, 12, 19)),
      RoomData(2, 250, DateTime(2023, 12, 19)),
      RoomData(3, 450, DateTime(2023, 12, 19)),
      RoomData(1, 210, DateTime(2023, 12, 20)),
      RoomData(2, 201, DateTime(2023, 12, 20)),
      RoomData(1, 202, DateTime(2023, 12, 21)),
    ];

    final Map<DateTime, List<RoomData>> groupedByDate = {};

    // Group by date
    for (var room in dummyList) {
      groupedByDate.putIfAbsent(room.date, () => []).add(room);
    }

    final List<CalendarEventData> eventList = groupedByDate.entries.map((entry) {
      final lowestPriceRoom = entry.value.reduce((curr, next) => curr.price < next.price ? curr : next);
      return CalendarEventData(
        date: entry.key,
        event: lowestPriceRoom.id.toString(),
        title: lowestPriceRoom.price.toInt().toString(),
      );
    }).toList();

    addCalendarEvent(eventList);
  }

  void addDummyRoomType() {

  }

  void showAdjustRoomPriceDialog(
      List<CalendarEventData<Object?>> events, DateTime selectedDate) {
    Get.dialog(
      Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: kWebWidth),
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
                Container(
                  constraints: const BoxConstraints(maxWidth: kWebWidth / 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Row for Titles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text('Old Price'),
                          SizedBox(width: 30), // Space for the icon
                          Text('New Price'),
                        ],
                      ),

                      const SizedBox(height: 8), // Spacing between rows

                      // Row for Price value, icon, and text field
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Old Price
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: const Text('RM 250'),
                          ),
                          // Icon
                          const Icon(Icons.arrow_forward, size: 30),
                          // New Price
                          const SizedBox(
                            width: 100,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                        showAdjustRoomPriceDialog(events, selectedDate);
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
      ),
      barrierDismissible: false,
    );
  }
}
