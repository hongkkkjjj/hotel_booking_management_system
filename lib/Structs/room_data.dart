
class RoomData {
  int id;
  double price;
  DateTime date;

  RoomData(this.id, this.price, this.date);
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