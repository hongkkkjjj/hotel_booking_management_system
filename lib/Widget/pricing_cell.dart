import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Constant/variable_type.dart';

class PricingCell extends StatelessWidget {
  final DateTime date;
  final List<CalendarEventData<Object?>> events;
  final bool isInMonth;
  final Color backgroundColor;
  final Color highlightColor;
  final Color titleColor;
  final Color highlightedTitleColor;
  final double highlightRadius;
  final bool shouldHighlight;
  final OnCellTapCallback onTapCallback;

  const PricingCell({
    super.key,
    required this.date,
    required this.events,
    this.isInMonth = false,
    this.backgroundColor = Colors.blue,
    this.highlightColor = Colors.blue,
    this.titleColor = Colors.black,
    this.highlightedTitleColor = Colors.teal,
    this.highlightRadius = 11,
    this.shouldHighlight = false,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          const SizedBox(
            height: kIsWeb ? 5.0 : 2.0,
          ),
          CircleAvatar(
            radius: highlightRadius,
            backgroundColor:
                shouldHighlight ? highlightColor : Colors.transparent,
            child: Text(
              "${date.day}",
              style: TextStyle(
                color: shouldHighlight
                    ? highlightedTitleColor
                    : isInMonth
                        ? titleColor
                        : titleColor.withOpacity(0.4),
                fontSize: kIsWeb ? 18 : 12,
              ),
            ),
          ),
          if (events.isNotEmpty)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: kIsWeb ? 5.0 : 0.0),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      events.length,
                      (index) => GestureDetector(
                        onTap: () => {
                          onTapCallback(events, date),
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: events[index].color,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 3.0,
                          ),
                          padding: const EdgeInsets.all(2.0),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  'RM ${events[index].title}',
                                  maxLines: 1,
                                  minFontSize: 6,
                                  textAlign: kIsWeb ? TextAlign.center : TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.grey[50],
                                    fontSize: kIsWeb ? 18 : 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
