import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_management_system/FirebaseController/storage_controller.dart';
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
        String description = data['description '] as String? ?? '-';
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

        return RoomType(doc.id, title, imageCount, squareFeet, squareMeter, description, guestCapacity, beds, price);
      }).toList();
      return rooms;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> addRoomData(RoomType room, List<XFile> images) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> roomData = room.toMap();  // Convert RoomType object to Map

    try {
      // Set the room data under 'rooms' collection with roomId
      await firestore.collection('rooms').doc(room.id).set(roomData);
      return await StorageController().uploadImages(room.id, images);
    } catch (e) {
      print("Error storing room data: $e");
      return false;
    }
  }
}
