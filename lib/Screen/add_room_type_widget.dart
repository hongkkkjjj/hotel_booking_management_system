import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Controller/rooms_controller.dart';
import 'package:hotel_booking_management_system/Widget/label_switch.dart';
import 'package:image_picker/image_picker.dart';

import '../Widget/custom_elevated_button.dart';

class AddRoomTypeScreen extends StatelessWidget {
  final RoomsController roomsController = Get.find<RoomsController>();

  AddRoomTypeScreen({super.key});

  List<PickedFile> images = <PickedFile>[];

  Future<void> loadAssets() async {
    List<XFile> resultList = <XFile>[];
    final ImagePicker picker = ImagePicker();

    try {
      resultList = await picker.pickMultiImage();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Add Room Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: loadAssets,
                child: const Text('Upload Room Images'),
              ),
              const SizedBox(height: 16.0),
              // Obx(() {
              //   // Display selected images
              //   // return Wrap(
              //   //   spacing: 8.0,
              //   //   runSpacing: 8.0,
              //   //   children: addRoomTypeController.images.map((Asset asset) {
              //   //     return Container(
              //   //       height: 100.0,
              //   //       width: 100.0,
              //   //       decoration: BoxDecoration(
              //   //         color: Colors.grey[200],
              //   //         borderRadius: BorderRadius.circular(8.0),
              //   //       ),
              //   //       child: AssetThumb(
              //   //         asset: asset,
              //   //         width: 100,
              //   //         height: 100,
              //   //       ),
              //   //     );
              //   //   }).toList(),
              //   // );
              //   return ColoredBox(color: Colors.amber);
              // }),
              const SizedBox(height: 16.0),
              const TextField(
                decoration: InputDecoration(labelText: 'Room Title'),
              ),
              const SizedBox(height: 16.0),
              LabelSwitch(
                firstLabel: 'Square Meter',
                secondLabel: 'Square Feet',
                roomsController: roomsController,
              ),
              const SizedBox(height: 16.0),
              Obx(() {
                return TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText:
                        'Size in ${roomsController.sizeType.value ? 'Square Meter (m\u00b2)' : 'Square Feet (ft\u00b2)'}',
                  ),
                );
              }),
              const SizedBox(height: 16.0),
              const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price (RM)'),
              ),
              const SizedBox(height: 16.0),
              const TextField(
                decoration: InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16.0),
              const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Can Accommodate How Many Persons'),
              ),
              const SizedBox(height: 16.0),
              const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantity of Rooms'),
              ),
              const SizedBox(height: 16.0),
              const Text('Bed Types:'),
              const SizedBox(height: 8.0),
              // Input fields for bed count for each bed type
              for (var bedType in [
                'Small Single',
                'Twin',
                'Full',
                'Queen',
                'King'
              ])
                TextField(
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Bed Count for $bedType'),
                ),
              const SizedBox(height: 24.0),
              CustomElevatedButton(
                icon: Icons.save,
                label: 'Save',
                backgroundColor: Colors.teal,
                onPressed: () {
                  // save room and go back
                },
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
