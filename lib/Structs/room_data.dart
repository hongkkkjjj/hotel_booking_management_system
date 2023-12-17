
class RoomData {
  int id;
  double price;
  DateTime date;

  RoomData(this.id, this.price, this.date);
}

class RoomType {
  int id;
  String title;
  bool isSquareFeet;
  double sizeValue;
  String description;
  int guestCapacity;
  List<BedType> bedTypes;

  RoomType(this.id, this.title, this.isSquareFeet, this.sizeValue, this.description, this.guestCapacity, this.bedTypes);
}

class BedType
{
  String id;
  String bedName;

  BedType(this.id, this.bedName);
}