
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_management_system/Utils/utils.dart';

class RoomType {
  String id;
  String title;
  int imageCount;
  int squareFeet;
  int squareMeter;
  String description;
  int guestCapacity;
  List<BedData> beds;
  int price;
  String updateBy = '';
  Timestamp lastUpdate;

  RoomType(this.id, this.title, this.imageCount, this.squareFeet, this.squareMeter, this.description, this.guestCapacity, this.beds, this.price, this.updateBy, this.lastUpdate);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'guest_capacity': guestCapacity,
      'image_count': imageCount,
      'square_feet': squareFeet,
      'square_meter': squareMeter,
      'price': price,
      'update_by': updateBy,
      'last_update': lastUpdate,
      'beds': { for (var bed in beds) bed.bedName : bed.count },
    };
  }
}

class BookedRoom {
  String id;
  DateTime startDate;
  DateTime endDate;

  BookedRoom(this.id, this.startDate, this.endDate);
}

class BedType
{
  String id;
  String bedName;

  BedType(this.id, this.bedName);
}

class BedData
{
  String bedName;
  int count;

  BedData(this.bedName, this.count);
}