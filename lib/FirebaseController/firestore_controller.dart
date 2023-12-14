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
      List<BedType> beds = querySnapshot.docs
          .map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        String bedName = data['bed_name'] as String? ?? 'Unknown';
        return BedType(doc.id, bedName);
      })
          .toList();
      return beds;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

}
