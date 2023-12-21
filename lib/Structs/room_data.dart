
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
  bool isSquareFeet;
  double sizeValue;
  String description;
  int guestCapacity;
  List<BedData> beds;
  double price;

  RoomType(this.id, this.title, this.imageCount, this.isSquareFeet, this.sizeValue, this.description, this.guestCapacity, this.beds, this.price);
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