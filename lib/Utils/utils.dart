import 'package:intl/intl.dart';

class Utils {
  static String formatDate(DateTime date, String format) {
    return DateFormat(format).format(date);
  }

  static DateTime formatStringDate(String date, String format) {
    return DateFormat(format).parse(date);
  }

  static bool isDateInRange(DateTime dateToCheck, DateTime rangeStartDate, DateTime rangeEndDate) {
    return dateToCheck.isAfter(rangeStartDate) && dateToCheck.isBefore(rangeEndDate);
  }
}
