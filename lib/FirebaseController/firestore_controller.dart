import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_management_system/FirebaseController/storage_controller.dart';
import 'package:hotel_booking_management_system/Utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../Structs/room_data.dart';

class FirestoreController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addUserData(String userId, Map<String, dynamic> userData) async {
    try {
      await firestore.collection('users').doc(userId).set(userData);
    } catch (e) {
      // Handle exceptions
      print(e.toString());
    }
  }

  Future<List<BedType>> getBedData() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('beds').get();
      List<BedType> beds = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        String bedName = data['bed_name'] as String? ?? 'Unknown';
        return BedType(doc.id, bedName);
      }).toList();
      return beds;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<RoomType>> getRoomData() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('rooms').get();
      List<RoomType> rooms = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        String title = data['title'] as String? ?? '-';
        String description = data['description'] as String? ?? '-';
        int guestCapacity = data['guest_capacity'] as int? ?? 0;
        int imageCount = data['image_count'] as int? ?? 0;
        int squareFeet = data['square_feet'] as int? ?? 0;
        int squareMeter = data['square_meter'] as int? ?? 0;
        int price = data['price'] as int? ?? 0;

        var bedsMap = data['beds'] as Map<String, dynamic>? ?? {};
        List<BedData> beds = bedsMap.entries.map((entry) {
          String bedName = entry.key;
          int count = entry.value as int? ?? 0;
          return BedData(bedName, count);
        }).toList();

        return RoomType(doc.id, title, imageCount, squareFeet, squareMeter,
            description, guestCapacity, beds, price);
      }).toList();
      return rooms;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> addRoomData(RoomType room, List<XFile> images) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> roomData =
        room.toMap(); // Convert RoomType object to Map

    try {
      // Set the room data under 'rooms' collection with roomId
      await firestore.collection('rooms').doc(room.id).set(roomData);
      return await StorageController().uploadImages(room.id, images);
    } catch (e) {
      print("Error storing room data: $e");
      return false;
    }
  }

  Future<List<CalendarRoom>> getCalendarRoomData() async {
    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('calendar_room').get();
      List<CalendarRoom> calendarRooms = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        String dateFormat = 'yyyy-MM-dd';
        String id = data['id'] as String? ?? '-';
        String date = data['date'] as String? ??
            Utils.formatDate(DateTime.now(), dateFormat);
        int price = data['price'] as int? ?? 0;
        DateTime formatDate = Utils.formatStringDate(date, dateFormat);

        return CalendarRoom(doc.id, id, price, formatDate);
      }).toList();
      return calendarRooms;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<void> updateRoomPrice(CalendarRoom room, List<XFile> images) async {
    Map<String, dynamic> roomData =
        room.toMap(); // Convert RoomType object to Map

    try {
      var result = await firestore.collection('rooms').doc().set(roomData);
      return result;
    } catch (e) {
      print("Error storing room data: $e");
      return;
    }
  }

  Future<Set<String>> getSearch(
    DateTime searchStartDate,
    DateTime searchEndDate,
  ) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('bookings')
          .get();

      Set<String> bookedRoomSet = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        String id = data['room_id'] as String? ?? '';
        Timestamp startTimestamp = data['start_date'] as Timestamp? ?? Timestamp.fromDate(DateTime.now());
        Timestamp endTimestamp = data['end_date'] as Timestamp? ?? Timestamp.fromDate(DateTime.now());

        DateTime startDate = startTimestamp.toDate();
        DateTime endDate = endTimestamp.toDate();

        // Check if searchStartDate is within the date range
        if (Utils.isDateInRange(searchStartDate, startDate, endDate)) {
          return id;
        }

        // Check if searchEndDate is within the date range
        if (Utils.isDateInRange(searchEndDate, startDate, endDate)) {
          return id;
        }

        return "";
      }).toSet();

      print("room set is ${bookedRoomSet}");

      return bookedRoomSet;
    } catch (e) {
      print(e.toString());

      return {};
    }
  }
}
