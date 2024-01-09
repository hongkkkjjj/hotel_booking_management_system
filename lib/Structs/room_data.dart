
import 'package:hotel_booking_management_system/Utils/utils.dart';

class CalendarRoom {
  String docId;
  String id;
  int price;
  DateTime date;

  CalendarRoom(this.docId, this.id, this.price, this.date);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price': price,
      'date': Utils.formatDate(date, "yyyy-MM-dd"),
    };
  }
}

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

  RoomType(this.id, this.title, this.imageCount, this.squareFeet, this.squareMeter, this.description, this.guestCapacity, this.beds, this.price);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'guest_capacity': guestCapacity,
      'image_count': imageCount,
      'square_feet': squareFeet,
      'square_meter': squareMeter,
      'price': price,
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