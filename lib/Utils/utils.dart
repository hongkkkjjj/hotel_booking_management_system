import 'package:intl/intl.dart';

class Utils {
  static String formatDate(DateTime date, String format) {
    return DateFormat(format).format(date);
  }
}
