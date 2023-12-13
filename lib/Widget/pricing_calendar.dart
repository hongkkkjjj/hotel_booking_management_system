import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_management_system/Widget/pricing_cell.dart';

import '../Constant/variable_type.dart';

class PricingCalendar extends StatelessWidget {
  final DateTime maxDate;
  final OnCellTapCallback onTapCallback;

  const PricingCalendar({Key? key, required this.maxDate, required this.onTapCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MonthView(
      cellAspectRatio: 1,
      minMonth: DateTime.now(),
      maxMonth: maxDate,
      borderColor: Colors.grey[850]!,
      borderSize: 0.2,
      cellBuilder: (date, events, isToday, isInMonth) {
        return PricingCell(
          date: date,
          events: events,
          shouldHighlight: isToday,
          isInMonth: isInMonth,
          backgroundColor: Colors.grey[200]!,
          highlightColor: Colors.orange,
          highlightedTitleColor: Colors.grey[900]!,
          onTapCallback: onTapCallback,
        );
      },
      onCellTap: (events, date) {
        print(events);
        onTapCallback(events, date);
      },
    );
  }
}
