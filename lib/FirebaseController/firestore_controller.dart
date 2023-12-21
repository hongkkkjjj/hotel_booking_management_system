import 'package:cloud_firestore/cloud_firestore.dart';

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
        bool isSquareFeet = data['is_square_feet'] as bool? ?? true;
        double sizeValue = data['size_value'] as double? ?? 0;
        double price = data['price'] as double? ?? 0;

        var bedsMap = data['beds'] as Map<String, dynamic>? ?? {};
        List<BedData> beds = bedsMap.entries.map((entry) {
          String bedName = entry.key;
          int count = entry.value as int? ?? 0;
          return BedData(bedName, count);
        }).toList();

        return RoomType(doc.id, title, imageCount, isSquareFeet, sizeValue, description, guestCapacity, beds, price);
      }).toList();
      return rooms;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
