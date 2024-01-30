import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_management_system/FirebaseController/storage_controller.dart';
import 'package:hotel_booking_management_system/Structs/booking_data.dart';
import 'package:hotel_booking_management_system/Structs/enums.dart';
import 'package:hotel_booking_management_system/Structs/user_data.dart';
import 'package:hotel_booking_management_system/Utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../Structs/room_data.dart';

class FirestoreController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> addUserData(String userId, Map<String, dynamic> userData) async {
    try {
      await firestore.collection('users').doc(userId).set(userData);
      return true;
    } catch (e) {
      // Handle exceptions
      print(e.toString());
      return false;
    }
  }

  Future<UserData?> getUserData(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> resultMap =
          await firestore.collection('users').doc(userId).get();

      if (resultMap.exists) {
        var data = resultMap.data();
        String username = data!['name'] as String? ?? '-';
        String mobileNo = data!['mobile_no'] as String? ?? '-';
        bool isAdmin = data!['is_admin'] as bool? ?? false;
        String email = data!['email'] as String? ?? '-';

        UserData userData = UserData(username, mobileNo, isAdmin, email);
        return userData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
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
        String updateBy = data['update_by'] as String? ?? "";
        Timestamp lastUpdate =
            data['last_update'] as Timestamp? ?? Timestamp.now();

        var bedsMap = data['beds'] as Map<String, dynamic>? ?? {};
        List<BedData> beds = bedsMap.entries.map((entry) {
          String bedName = entry.key;
          int count = entry.value as int? ?? 0;
          return BedData(bedName, count);
        }).toList();

        return RoomType(
          doc.id,
          title,
          imageCount,
          squareFeet,
          squareMeter,
          description,
          guestCapacity,
          beds,
          price,
          updateBy,
          lastUpdate,
        );
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
        DateTime formatDate = Utils.parseDateFrom(date, dateFormat);

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
          .where('status', whereIn: [0, 1, 3]).get();

      Set<String> bookedRoomSet = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        String id = data['room_id'] as String? ?? '';
        Timestamp startTimestamp = data['start_date'] as Timestamp? ??
            Timestamp.fromDate(DateTime.now());
        Timestamp endTimestamp = data['end_date'] as Timestamp? ??
            Timestamp.fromDate(DateTime.now());

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

  Future<bool> addBookingData(Map<String, dynamic> bookingData) async {
    try {
      await firestore.collection('bookings').doc().set(bookingData);
      return true;
    } catch (e) {
      // Handle exceptions
      print(e.toString());
      return false;
    }
  }

  Future<List<BookingData>> getBookingDataForUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('bookings')
          .where('user_id', isEqualTo: userId)
          .get();
      List<BookingData> bookingList = querySnapshot.docs.map((doc) {
        String docId = doc.reference.id;
        var data = doc.data() as Map<String, dynamic>;

        String roomId = data['room_id'] as String? ?? '';
        Timestamp endDate = data['end_date'] as Timestamp? ??
            Timestamp.fromDate(DateTime.now());
        Timestamp startDate = data['start_date'] as Timestamp? ??
            Timestamp.fromDate(DateTime.now());
        int pricePerNight = data['price_per_night'] as int? ?? 0;
        int totalPrice = data['total_price'] as int? ?? 0;
        int duration = data['duration'] as int? ?? 0;
        int guestCount = data['guest_count'] as int? ?? 0;
        int status = data['status'] as int? ?? 0;
        String updateBy = data['updated_by'] as String? ?? '';
        Timestamp lastUpdate = data['last_update'] as Timestamp? ??
            Timestamp.fromDate(DateTime.now());

        return BookingData(
            docId,
            startDate,
            endDate,
            roomId,
            status,
            pricePerNight,
            totalPrice,
            duration,
            userId,
            guestCount,
            updateBy,
            lastUpdate);
      }).toList();
      return bookingList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<BookingData>> getBookingDataForAdmin() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('bookings')
          .where('end_date', isGreaterThan: Timestamp.now())
          .where('status', whereIn: [0, 1, 3]).get();
      List<BookingData> bookingList = querySnapshot.docs.map((doc) {
        String docId = doc.reference.id;
        var data = doc.data() as Map<String, dynamic>;

        String roomId = data['room_id'] as String? ?? '';
        Timestamp endDate = data['end_date'] as Timestamp? ??
            Timestamp.fromDate(DateTime.now());
        Timestamp startDate = data['start_date'] as Timestamp? ??
            Timestamp.fromDate(DateTime.now());
        int pricePerNight = data['price_per_night'] as int? ?? 0;
        int totalPrice = data['total_price'] as int? ?? 0;
        int duration = data['duration'] as int? ?? 0;
        String userId = data['user_id'] as String? ?? '';
        int guestCount = data['guest_count'] as int? ?? 0;
        int status = data['status'] as int? ?? 0;
        String updateBy = data['updated_by'] as String? ?? '';
        Timestamp lastUpdate = data['last_update'] as Timestamp? ??
            Timestamp.fromDate(DateTime.now());

        return BookingData(
            docId,
            startDate,
            endDate,
            roomId,
            status,
            pricePerNight,
            totalPrice,
            duration,
            userId,
            guestCount,
            updateBy,
            lastUpdate);
      }).toList();
      return bookingList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> updateBookingStatus(
      String bookingId, Map<String, dynamic> bookingData) async {
    try {
      await firestore.collection('bookings').doc(bookingId).set(bookingData);
      return true;
    } catch (e) {
      // Handle exceptions
      print(e.toString());
      return false;
    }
  }
}
