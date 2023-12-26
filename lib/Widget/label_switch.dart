import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Controller/rooms_controller.dart';

import '../Constant/app_const.dart';

class LabelSwitch extends StatefulWidget {
  final String firstLabel;
  final String secondLabel;
  final RoomsController roomsController;

  const LabelSwitch({
    super.key,
    required this.firstLabel,
    required this.secondLabel,
    required this.roomsController,
  });

  @override
  LabelSwitchState createState() => LabelSwitchState();
}

class LabelSwitchState extends State<LabelSwitch> {
  @override
  Widget build(BuildContext context) {
    // var sizeType = widget.roomsController.sizeType;
    var sizeType = false;

    return GestureDetector(
      onTap: () {
        // widget.roomsController.sizeType.toggle();
        sizeType = !sizeType;
      },
      child: Container(
        width: double.infinity, // Full width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: kSecondaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Obx(() {
                  return Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: sizeType ? Colors.white : kSecondaryColor,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.firstLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: sizeType ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8.0), // Add some spacing between labels
              Expanded(
                child: Obx(() {
                  return Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: sizeType ? kSecondaryColor : Colors.white,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.secondLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: sizeType ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
