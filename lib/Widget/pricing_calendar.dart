import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class PricingCalendar extends StatelessWidget {
  final DateTime maxDate;


  const PricingCalendar({Key? key, required this.maxDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MonthView(
      cellAspectRatio: 1,
      minMonth: DateTime.now(),
      maxMonth: maxDate,
      borderColor: Colors.teal,
      cellBuilder: (date, events, isToday, isInMonth) {
        return Container();
      },
      onCellTap: (events, date) {
        // Implement callback when user taps on a cell.
        print(events);
      },
    );
  }
}

