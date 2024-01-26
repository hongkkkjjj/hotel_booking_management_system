import 'package:cloud_firestore/cloud_firestore.dart';

class BookingData {
  Timestamp startDate;
  Timestamp endDate;
  String roomId;
  int status;
  int totalPrice;
  String userId;
  String updateBy = '';
  Timestamp lastUpdate;

  BookingData(this.startDate, this.endDate, this.roomId, this.status, this.totalPrice, this.userId, this.updateBy, this.lastUpdate);

  Map<String, dynamic> toMap() {
    return {
      'end_date': endDate,
      'start_date': startDate,
      'room_id': roomId,
      'last_update': lastUpdate,
      'status': status,
      'total_price': totalPrice,
      'updated_by': updateBy,
      'user_id': userId,
    };
  }
}