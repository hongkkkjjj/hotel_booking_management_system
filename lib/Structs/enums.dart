enum AddRoomScreenType { Add, Edit, View }

enum BookingStatus { Unpaid, Paid, Cancelled, CheckIn, Completed }

BookingStatus mapIntToBookingStatus(int status) {
  switch (status) {
    case 0:
      return BookingStatus.Unpaid;
    case 1:
      return BookingStatus.Paid;
    case 2:
      return BookingStatus.Cancelled;
    case 3:
      return BookingStatus.CheckIn;
    case 4:
      return BookingStatus.Completed;
    default:
      throw Exception('Invalid status code: $status');
  }
}

extension BookingStatusExtension on BookingStatus {
  String get statusString {
    switch (this) {
      case BookingStatus.Unpaid:
        return 'Unpaid';
      case BookingStatus.Paid:
        return 'Paid';
      case BookingStatus.Cancelled:
        return 'Cancelled';
      case BookingStatus.CheckIn:
        return 'Check In';
      case BookingStatus.Completed:
        return 'Completed';
      default:
        throw Exception('Invalid status: $this');
    }
  }
}
