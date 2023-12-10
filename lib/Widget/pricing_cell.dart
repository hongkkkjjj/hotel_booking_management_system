import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class PricingCell extends StatelessWidget {
  final Color backgroundColor;
  final Color highlightColor;
  final double highlightRadius;
  final bool shouldHighlight;

  const PricingCell({
    super.key,
    this.backgroundColor = Colors.blue,
    this.highlightColor = Colors.blue,
    this.highlightRadius = 11,
    this.shouldHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          const SizedBox(
            height: 5.0,
          ),
          CircleAvatar(
            radius: highlightRadius,
            backgroundColor:
                shouldHighlight ? highlightColor : Colors.transparent,
            child: Text(
              dateStringBuilder?.call(date) ?? "${date.day}",
              style: TextStyle(
                color: shouldHighlight
                    ? highlightedTitleColor
                    : isInMonth
                        ? titleColor
                        : titleColor.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ),
          if (events.isNotEmpty)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 5.0),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      events.length,
                      (index) => GestureDetector(
                        onTap: () =>
                            onTileTap?.call(events[index], events[index].date),
                        child: Container(
                          decoration: BoxDecoration(
                            color: events[index].color,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 3.0),
                          padding: const EdgeInsets.all(2.0),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  events[index].title,
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: events[0].titleStyle ??
                                      TextStyle(
                                        color: events[index].color.accent,
                                        fontSize: 12,
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
