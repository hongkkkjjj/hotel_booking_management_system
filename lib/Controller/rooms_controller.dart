import 'dart:math';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../FirebaseController/firestore_controller.dart';
import '../Structs/room_data.dart';
import '../Utils/utils.dart';

class RoomsController extends GetxController {
  RxBool sizeType = true.obs;
  EventController eventController = EventController();
  List<CalendarEventData> eventList = <CalendarEventData>[].obs;
  List<RoomType> roomList = <RoomType>[].obs;
  List<BedType> bedTypes = <BedType>[].obs;

  FirestoreController firestoreController = FirestoreController();

  @override
  void onInit() {
    super.onInit();
    getBedData();
    getRoomData();
  }

  void getBedData() async {
    bedTypes = await firestoreController.getBedData();
    for (var bed in bedTypes) {
      print('Bed ID: ${bed.id}, Bed Name: ${bed.bedName}');
    }
  }

  void getRoomData() async {
    roomList = await firestoreController.getRoomData();
    for (var room in roomList) {
      print('Room ID: ${room.id}, Title: ${room.title}, Price: ${room.price}');
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
    if (eventList.isNotEmpty) {
      return;
    }

    final Random random = Random();

    // Default array with room ID and random default prices
    final Map<int, double> defaultPrices = {
      for (int i = 1; i <= 3; i++) i: 200 + random.nextInt(50).toDouble()
    };

    // Generate dummy list
    final List<RoomData> dummyList = List.generate(30, (index) {
      DateTime date = DateTime.now().add(Duration(days: index));
      int roomId = random.nextInt(3) + 1; // Random room ID (1-3)
      double price = defaultPrices[roomId]! + random.nextInt(20) - 10; // Adjust price randomly
      return RoomData(roomId, price, date);
    });

    groupAndSortRoomData(dummyList, defaultPrices);
  }

  void groupAndSortRoomData(List<RoomData> dummyList, Map<int, double> defaultPrices) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime maxDate = DateTime.now().add(const Duration(days: 2)); // 2 months from today
    final Map<DateTime, List<RoomData>> groupedByDate = {};

    // Initial grouping by date
    for (var room in dummyList) {
      groupedByDate.putIfAbsent(DateTime(room.date.year, room.date.month, room.date.day), () => []).add(room);
    }

    List<CalendarEventData> eventList = [];

    for (DateTime date = today; date.isBefore(maxDate); date = date.add(const Duration(days: 1))) {
      DateTime startTime = DateTime(date.year, date.month, date.day);
      DateTime endTime = DateTime(date.year, date.month, date.day, 23, 59, 59);

      for (var roomId = 1; roomId <= 3; roomId++) {
        var roomDataForDateAndId = groupedByDate[date]!.firstWhere(
              (room) => room.id == roomId,
          orElse: () => RoomData(roomId, defaultPrices[roomId]!, date),
        );

        eventList.add(CalendarEventData(
          date: date,
          startTime: startTime, // Start of the day
          endTime: endTime, // End of the day (23:59:59)
          event: roomDataForDateAndId.id.toString(),
          title: roomDataForDateAndId.price.toInt().toString(),
        ));
      }
    }

    eventList.forEach((event) => print("Date: ${event.date}, ID: ${event.event}, Price: ${event.title}"));
    print('event count ${eventList.length}');
    addCalendarEvent(eventList);
  }

  List<CalendarEventData> filterEventsBySelectedDate(DateTime selectedDate) {
    return eventList.where((event) {
      return isSameDay(event.date, selectedDate);
    }).toList();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  void showAdjustRoomPriceDialog(
      List<CalendarEventData<Object?>> events, DateTime selectedDate) {

    if (events.isEmpty) {
      return;
    }

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    bool isAfter = selectedDate.isAfter(yesterday);

    Get.dialog(
      Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  Utils.formatDate(selectedDate, 'yyyy-MM-dd'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // loop all bed type
                const Row(
                  children: [
                    Text(
                      'Room',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                for (var event in events)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(event.title),
                          ),
                        ),
                        SizedBox(
                          width: 85,
                          child: TextField(
                            enabled: false,
                            // Makes the TextField non-editable
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black, // Set text color to black
                            ),
                            controller: TextEditingController(
                              text: 'RM ${event.title}',
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward, size: 24),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            enabled: isAfter,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: "",
                              hintText: '0',
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 4.0, right: 4.0),
                                child: Text('RM'),
                              ),
                              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                // Buttons Row
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
                    const SizedBox(
                      width: 10,
                    ),
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
      ),
      barrierDismissible: false,
    );
  }
}


// The home screen I not yet done, but the concept is
// * Home Screen (Normal user)
// - Welcome xxx (name)
// - 2x2 box that will ask for person to stay, checkin date, checkout date, prefer type (optional)
// - Search button below box (Check availability)
// - Go booking screen
// - Current booking details
// - Cell of room details, with checkout date and checkin date on top
// - Edit booking button below
//
// * Home Screen (Admin)
// - Welcome xxx (name)
// - Current staying user, new booking request (Top section, like table row, small pop up icon on both cell)
// - If staying user pop up, all customer name, room number, staying date, checkout date, duration)
// - If booking request pop up, show details (room number, staying date, checkout date, duration, booking user name, mobile no)
// - Calendar with Ongoing staying customer on that day
// - If click on that day will pop up same screen like staying user, but focus on that day

