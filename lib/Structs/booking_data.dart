import 'package:cloud_firestore/cloud_firestore.dart';

class BookingData {
  String bookingId;
  Timestamp startDate;
  Timestamp endDate;
  String roomId;
  int status;
  int pricePerNight;
  int totalPrice;
  int duration;
  String userId;
  int guestCount;
  String updateBy = '';
  Timestamp lastUpdate;

  BookingData(this.bookingId, this.startDate, this.endDate, this.roomId, this.status, this.pricePerNight, this.totalPrice, this.duration, this.userId, this.guestCount, this.updateBy, this.lastUpdate);

  Map<String, dynamic> toMap() {
    return {
      'end_date': endDate,
      'start_date': startDate,
      'room_id': roomId,
      'last_update': lastUpdate,
      'status': status,
      'price_per_night': pricePerNight,
      'total_price': totalPrice,
      'duration': duration,
      'guest_count': guestCount,
      'updated_by': updateBy,
      'user_id': userId,
    };
  }
}