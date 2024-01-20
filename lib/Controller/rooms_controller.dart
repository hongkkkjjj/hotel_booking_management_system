import 'dart:math';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Constant/app_const.dart';
import 'package:hotel_booking_management_system/Structs/enums.dart';
import 'package:image_picker/image_picker.dart';

import '../Constant/app_route.dart';
import '../FirebaseController/firestore_controller.dart';
import '../FirebaseController/storage_controller.dart';
import '../Structs/room_data.dart';
import '../Utils/utils.dart';

class RoomsController extends GetxController {
  EventController eventController = EventController();
  List<CalendarEventData> eventList = <CalendarEventData>[].obs;
  List<RoomType> roomList = <RoomType>[].obs;
  List<RoomType> searchRoomList = <RoomType>[].obs;
  List<CalendarRoom> calendarRoomList = <CalendarRoom>[].obs;
  List<BedType> bedTypes = <BedType>[].obs;
  List<XFile> capturedImageList = <XFile>[];
  var imageUrls = <String, List<String>>{}.obs;
  Set<String> filterSet = {};
  bool isSearch = false;
  int searchDuration = 0;

  // Add room
  AddRoomScreenType addRoomScreenType = AddRoomScreenType.Add;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController squareFeetController = TextEditingController();
  final TextEditingController squareMeterController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController guestCapController = TextEditingController();
  List<TextEditingController> bedCountControllers = [];
  FocusNode squareMeterFocusNode = FocusNode();
  FocusNode squareFeetFocusNode = FocusNode();

  FirestoreController firestoreController = FirestoreController();

  @override
  void onInit() {
    super.onInit();
    getBedData().then((_) {
      bedCountControllers = List.generate(
        bedTypes.length,
        (index) => TextEditingController(),
      );
    });

    getRoomData();
    squareMeterFocusNode.addListener(() {
      if (!squareMeterFocusNode.hasFocus) {
        convertToSquareFeet();
      }
    });
    squareFeetFocusNode.addListener(() {
      if (!squareFeetFocusNode.hasFocus) {
        convertToSquareMeters();
      }
    });
  }

  @override
  void onClose() {
    squareMeterFocusNode.dispose();
    squareFeetFocusNode.dispose();
    super.onClose();
  }

  Future<void> getBedData() async {
    try {
      var fetchedBedTypes = await firestoreController.getBedData();
      bedTypes.assignAll(fetchedBedTypes); // Assign the fetched data
    } catch (e) {
      print("Error fetching bed data: $e");
    }
  }

  void getRoomData() async {
    roomList = await firestoreController.getRoomData();
    for (var room in roomList) {
      print('Room ID: ${room.id}, Title: ${room.title}, Price: ${room.price}');
      loadImages(room.id, room.imageCount);
    }

    addCalendarRoomData();
  }

  void addCalendarEvent(List<CalendarEventData> list) {
    eventList = list;
    eventController.addAll(list);
  }

  // region Get room data

  // region Get room image

  Future<void> loadImages(String bedTypeId, int imageCount) async {
    try {
      // Ensure a list exists for this bedTypeId, otherwise create it
      imageUrls[bedTypeId] = imageUrls[bedTypeId] ?? [];

      for (int i = 0; i < imageCount; i++) {
        String imagePath = 'images/$bedTypeId-$i.jpg';
        String url = await StorageController().getImageUrl(imagePath);
        imageUrls[bedTypeId]?.add(url); // Add the URL to the list for this bedTypeId
      }
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  // endregion

  // region Get Calendar Room Data



  void addCalendarRoomData() {
    if (eventList.isNotEmpty) {
      return;
    }

    final Map<int, int> priceList = {};

    for (RoomType room in roomList) {
      int roomId = int.parse(room.id);
      priceList[roomId] = room.price;
    }

    List<CalendarRoom> calendarRoomList = [];

    groupAndSortRoomData(calendarRoomList, priceList);
  }

  // endregion

  // region Get event list

  void groupAndSortRoomData(
      List<CalendarRoom> calendarRoomList, Map<int, int> defaultPrices) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime maxDate =
        DateTime.now().add(const Duration(days: 60)); // 2 months from today
    final Map<DateTime, List<CalendarRoom>> groupedByDate = {};

    // Initial grouping by date
    for (var room in calendarRoomList) {
      groupedByDate
          .putIfAbsent(DateTime(room.date.year, room.date.month, room.date.day),
              () => [])
          .add(room);
    }

    List<CalendarEventData> eventList = [];

    for (DateTime date = today;
        date.isBefore(maxDate);
        date = date.add(const Duration(days: 1))) {
      DateTime startTime = DateTime(date.year, date.month, date.day);
      DateTime endTime = DateTime(date.year, date.month, date.day, 23, 59, 59);

      for (var roomId = 0; roomId < roomList.length; roomId++) {
        var roomDataForDateAndId = (groupedByDate[date] ?? []).firstWhere(
              (room) => room.id == roomId.toString(),
          orElse: () => CalendarRoom('', roomId.toString(), defaultPrices[roomId] ?? 0, date),
        );

        eventList.add(CalendarEventData(
          date: date,
          startTime: startTime,
          // Start of the day
          endTime: endTime,
          // End of the day (23:59:59)
          event: roomDataForDateAndId.id.toString(),
          title: roomDataForDateAndId.price.toInt().toString(),
        ));
      }
    }

    for (var event in eventList) {
      print(
        "Date: ${event.date}, ID: ${event.event}, Price: ${event.title}");
    }
    print('event count ${eventList.length}');
    addCalendarEvent(eventList);
  }

  List<CalendarEventData> filterEventsBySelectedDate(DateTime selectedDate) {
    return eventList.where((event) {
      return isSameDay(event.date, selectedDate);
    }).toList();
  }

  // endregion

  // endregion

  // region Add new room

  void createNewRoom(BuildContext context) async {
    var id = (int.parse(roomList.last.id) + 1).toString();
    List<BedData> bedsList = [];
    for (int i = 0; i < bedTypes.length; i++) {
      String text = bedCountControllers[i].text;
      if (text.isNotEmpty && text != '0') {
        int count = int.tryParse(text) ?? 0;
        bedsList.add(BedData(bedTypes[i].bedName, count));
      }
    }

    var room = RoomType(
      id,
      titleController.text,
      capturedImageList.length,
      int.parse(squareFeetController.text),
      int.parse(squareMeterController.text),
      descriptionController.text,
      int.parse(guestCapController.text),
      bedsList,
      int.parse(priceController.text),
    );

    var result = await firestoreController.addRoomData(room, capturedImageList);

    if (result) {
      clearEditingController();
      if (!context.mounted) return;
      _showUploadDialog(context, '', 'Successfully add new room', () {
        getRoomData();
        Get.offNamed(Routes.home);
      });
    } else {
      if (!context.mounted) return;
      _showUploadDialog(context, '', 'Something wrong is happened. Please try again.', null);
    }
  }

  void updateRoom(BuildContext context, int index) async {
    String id = roomList[index].id;
    List<BedData> bedsList = [];
    for (int i = 0; i < bedTypes.length; i++) {
      String text = bedCountControllers[i].text;
      if (text.isNotEmpty && text != '0') {
        int count = int.tryParse(text) ?? 0;
        bedsList.add(BedData(bedTypes[i].bedName, count));
      }
    }

    var room = RoomType(
      id,
      titleController.text,
      capturedImageList.length,
      int.parse(squareFeetController.text),
      int.parse(squareMeterController.text),
      descriptionController.text,
      int.parse(guestCapController.text),
      bedsList,
      int.parse(priceController.text),
    );

    var result = await firestoreController.addRoomData(room, capturedImageList);

    if (result) {
      clearEditingController();
      if (!context.mounted) return;
      _showUploadDialog(context, '', 'Successfully update room detail', () {
        getRoomData();
        Get.offNamed(Routes.home);
      });
    } else {
      if (!context.mounted) return;
      _showUploadDialog(context, '', 'Something wrong is happened. Please try again.', null);
    }
  }

  void addRoomDataToEditingController(int index) {
    var selectedRoom = roomList[index];
    titleController.text = selectedRoom.title;
    squareFeetController.text = selectedRoom.squareFeet.toString();
    squareMeterController.text = selectedRoom.squareMeter.toString();
    descriptionController.text = selectedRoom.description;
    guestCapController.text = selectedRoom.guestCapacity.toString();
    priceController.text = selectedRoom.price.toString();

    for (var i in selectedRoom.beds) {
      var index = bedTypes.indexWhere((bed) => bed.bedName == i.bedName);
      if (index >= 0) {
        bedCountControllers[index].text = i.count.toString();
      }
    }
  }

  void clearEditingController()
  {
    capturedImageList = [];
    titleController.text = '';
    squareFeetController.text = '';
    squareMeterController.text = '';
    descriptionController.text = '';
    guestCapController.text = '';
    priceController.text = '';
  }

  void _showUploadDialog(BuildContext context, String title, String content, VoidCallback? onDialogClose) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();

                if (onDialogClose != null) {
                  onDialogClose();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // endregion

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // region Conversion

  void convertToSquareFeet() {
    if (squareMeterController.text.isNotEmpty) {
      double meters = double.parse(squareMeterController.text);
      int feet = (meters * 10.7639).round();
      if (squareFeetController.text != feet.toString()) {
        squareFeetController.text = feet.toString();
      }
    }
  }

  void convertToSquareMeters() {
    if (squareFeetController.text.isNotEmpty) {
      double feet = double.parse(squareFeetController.text);
      int meters = (feet * 0.092903).round();
      if (squareMeterController.text != meters.toString()) {
        squareMeterController.text = meters.toString();
      }
    }
  }

  // endregion

  // region Adjust Price Dialog

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
                    child: buildRoomPriceRow(event, isAfter),
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
                        // firestoreController.
                        // var room = calendarRoomList.firstWhereOrNull((room) => room.id == )
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

  Widget buildRoomPriceRow(CalendarEventData event, bool isAfter) {
    if (kIsWeb) {
      // Web layout: All components in one row
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildTitle(event),
          buildOldPrice(event),
          const Icon(Icons.arrow_forward, size: 24),
          buildNewPrice(isAfter),
        ],
      );
    } else {
      // Non-web layout: Components split into two rows
      return Column(
        children: <Widget>[
          // First Row: Title and Spacer
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildTitle(event),
                const Spacer(),
              ],
            ),
          ),
          // Second Row: Old Price, Arrow Icon, and New Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildOldPrice(event),
              const Icon(Icons.arrow_forward, size: 24),
              buildNewPrice(isAfter),
            ],
          ),
        ],
      );
    }
  }

  Widget buildTitle(CalendarEventData event) {
    return SizedBox(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(findRoomNameByEvent(event)),
      ),
    );
  }

  Widget buildOldPrice(CalendarEventData event) {
    return SizedBox(
      width: 85,
      child: TextField(
        enabled: false,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        style: const TextStyle(color: Colors.black),
        controller: TextEditingController(text: 'RM ${event.title}'),
      ),
    );
  }

  Widget buildNewPrice(bool isAfter) {
    return SizedBox(
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
    );
  }

  String findRoomNameByEvent(CalendarEventData event) {
    String eventIdAsString = event.event.toString();

    RoomType? room = roomList.firstWhereOrNull((room) => room.id == eventIdAsString);

    return room?.title ?? 'Room not found';
  }

// endregion
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
