import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Controller/rooms_controller.dart';
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
      roomsController.imageList = resultList;
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
              Center(
                child: ElevatedButton(
                  onPressed: loadAssets,
                  child: const Text('Upload Room Images'),
                ),
              ),

              const SizedBox(height: 16.0),
              TextField(
                decoration: const InputDecoration(labelText: 'Room Title'),
                controller: roomsController.titleController,
              ),
              const SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.number,
                controller: roomsController.squareFeetController,
                decoration: const InputDecoration(
                  labelText: 'Size in Square Feet (ft\u00b2)',
                ),
                focusNode: roomsController.squareFeetFocusNode,
                onEditingComplete: roomsController.convertToSquareMeters,
              ),
              const SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.number,
                controller: roomsController.squareMeterController,
                decoration: const InputDecoration(
                  labelText: 'Size in Square Meter (m\u00b2)',
                ),
                focusNode: roomsController.squareMeterFocusNode,
                onEditingComplete: roomsController.convertToSquareFeet,
              ),
              const SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.number,
                controller: roomsController.priceController,
                decoration: const InputDecoration(labelText: 'Price (RM)'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: roomsController.descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.number,
                controller: roomsController.guestCapController,
                decoration: const InputDecoration(
                    labelText: 'Can Accommodate How Many Persons'),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Bed Type (Leave empty if 0)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8.0),
              // Input fields for bed count for each bed type
              ...List.generate(roomsController.bedTypes.length, (index) {
                var bedType = roomsController.bedTypes[index];
                return TextField(
                  keyboardType: TextInputType.number,
                  controller: roomsController.bedCountControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Bed Count for ${bedType.bedName}',
                  ),
                );
              }),
              const SizedBox(height: 24.0),
              CustomElevatedButton(
                icon: Icons.save,
                label: 'Save',
                backgroundColor: Colors.teal,
                onPressed: () {
                  roomsController.createNewRoom(context);
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
