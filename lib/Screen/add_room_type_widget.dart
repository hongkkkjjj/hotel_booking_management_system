import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Controller/rooms_controller.dart';
import 'package:hotel_booking_management_system/Structs/enums.dart';
import 'package:image_picker/image_picker.dart';

import '../Widget/custom_elevated_button.dart';

class AddRoomTypeScreen extends StatelessWidget {
  final RoomsController roomsController = Get.find<RoomsController>();

  AddRoomTypeScreen({super.key});

  List<PickedFile> images = <PickedFile>[];
  int roomSequence = 0;

  Future<void> loadAssets() async {
    List<XFile> resultList = <XFile>[];
    final ImagePicker picker = ImagePicker();

    try {
      resultList = await picker.pickMultiImage();
      roomsController.capturedImageList = resultList;
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var arg = Get.arguments;
    roomSequence = arg["room_id"] ?? 0;
    bool isTextFieldEnable =
        roomsController.addRoomScreenType != AddRoomScreenType.View;

    roomsController.clearEditingController();

    if (roomsController.addRoomScreenType != AddRoomScreenType.Add) {
      roomsController.addRoomDataToEditingController(roomSequence);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: appBarTitle(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageViewSection(),
              const SizedBox(height: 16.0),
              TextField(
                enabled: isTextFieldEnable,
                decoration: const InputDecoration(
                  labelText: 'Room Title',
                  labelStyle: TextStyle(color: Colors.black),
                  disabledBorder: InputBorder.none,
                ),
                controller: roomsController.titleController,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16.0),
              TextField(
                enabled: isTextFieldEnable,
                keyboardType: TextInputType.number,
                controller: roomsController.squareFeetController,
                decoration: const InputDecoration(
                  labelText: 'Size in Square Feet (ft\u00b2)',
                  labelStyle: TextStyle(color: Colors.black),
                  disabledBorder: InputBorder.none,
                ),
                focusNode: roomsController.squareFeetFocusNode,
                onEditingComplete: roomsController.convertToSquareMeters,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16.0),
              TextField(
                enabled: isTextFieldEnable,
                keyboardType: TextInputType.number,
                controller: roomsController.squareMeterController,
                decoration: const InputDecoration(
                  labelText: 'Size in Square Meter (m\u00b2)',
                  labelStyle: TextStyle(color: Colors.black),
                  disabledBorder: InputBorder.none,
                ),
                focusNode: roomsController.squareMeterFocusNode,
                onEditingComplete: roomsController.convertToSquareFeet,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16.0),
              TextField(
                enabled: isTextFieldEnable,
                keyboardType: TextInputType.number,
                controller: roomsController.priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (RM)',
                  labelStyle: TextStyle(color: Colors.black),
                  disabledBorder: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16.0),
              TextField(
                maxLines: null,
                enabled: isTextFieldEnable,
                controller: roomsController.descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.black),
                  disabledBorder: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16.0),
              TextField(
                enabled: isTextFieldEnable,
                keyboardType: TextInputType.number,
                controller: roomsController.guestCapController,
                decoration: const InputDecoration(
                  labelText: 'Can Accommodate How Many Persons',
                  labelStyle: TextStyle(color: Colors.black),
                  disabledBorder: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 24.0),
              Text(
                (isTextFieldEnable) ? 'Bed Type (Leave empty if 0)' : 'Beds',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8.0),
              // Input fields for bed count for each bed type
              ...bedSection(context, isTextFieldEnable),
              const SizedBox(height: 24.0),
              bottomButton(context, roomSequence),
            ],
          ),
        ),
      ),
    );
  }

  Widget appBarTitle() {
    switch (roomsController.addRoomScreenType) {
      case AddRoomScreenType.Add:
        return const Text('Add Room');
      case AddRoomScreenType.Edit:
        return const Text('Edit Room');
      case AddRoomScreenType.View:
        return const Text('View Room');
    }
  }

  Widget imageViewSection() {
    Widget customCachedNetworkImage(String imgStr) {
      if (roomsController.addRoomScreenType == AddRoomScreenType.Edit) {
        return CachedNetworkImage(
          imageUrl: imgStr,
          placeholder: (context, url) => const SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/img_no_img.png',
            fit: BoxFit.fill,
          ),
          fit: BoxFit.fill,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
            ),
          ),
        );
      } else {
        return CachedNetworkImage(
          imageUrl: imgStr,
          placeholder: (context, url) => const SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/img_no_img.png',
            fit: BoxFit.fill,
          ),
          fit: BoxFit.fill,
        );
      }
    }

    Widget imageWidget(String imgStr) {
      if (imgStr.isEmpty) {
        return Image.asset(
          'assets/images/img_no_img.png',
          fit: BoxFit.fill,
        );
      } else {
        return customCachedNetworkImage(imgStr);
      }
    }

    switch (roomsController.addRoomScreenType) {
      case AddRoomScreenType.Add:
        return Center(
          child: ElevatedButton(
            onPressed: loadAssets,
            child: const Text('Upload Room Images'),
          ),
        );
      case AddRoomScreenType.Edit:
      case AddRoomScreenType.View:
        var selectedImgList =
            roomsController.imageUrls[roomSequence.toString()] ?? [];

        return InkWell(
          onTap: loadAssets,
          child: SizedBox(
            width: kIsWeb ? 600 : 400,
            height: kIsWeb ? 300 : 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: selectedImgList.length,
              itemBuilder: (BuildContext context, int index) {
                var imgStr = selectedImgList[index];

                return SizedBox(
                  width: kIsWeb ? 600 : 400,
                  height: kIsWeb ? 300 : 200,
                  child: imageWidget(imgStr),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                width: 10,
              ),
            ),
          ),
        );
    }
  }

  List<Widget> bedSection(BuildContext context, bool isTextFieldEnable) {
    // var bedList = isTextFieldEnable ? roomsController.roomList[roomSequence].beds : roomsController.bedTypes;

    if (roomsController.addRoomScreenType == AddRoomScreenType.View) {
      return List.generate(roomsController.roomList[roomSequence].beds.length,
          (index) {
        var bedType = roomsController.roomList[roomSequence].beds[index];
        return TextField(
          enabled: isTextFieldEnable,
          keyboardType: TextInputType.number,
          controller: roomsController.bedCountControllers[index],
          decoration: InputDecoration(
            labelText: 'Bed Count for ${bedType.bedName}',
            labelStyle: const TextStyle(color: Colors.black),
            disabledBorder: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.black),
        );
      });
    } else {
      return List.generate(roomsController.bedTypes.length, (index) {
        var bedType = roomsController.bedTypes[index];
        return TextField(
          enabled: isTextFieldEnable,
          keyboardType: TextInputType.number,
          controller: roomsController.bedCountControllers[index],
          decoration: InputDecoration(
            labelText: 'Bed Count for ${bedType.bedName}',
            labelStyle: const TextStyle(color: Colors.black),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          style: const TextStyle(color: Colors.black),
        );
      });
    }
  }

  Widget bottomButton(BuildContext context, int index) {
    if (roomsController.addRoomScreenType == AddRoomScreenType.View) {
      return const SizedBox(height: 0);
    } else {
      bool isAddRoom =
          roomsController.addRoomScreenType == AddRoomScreenType.Add;

      return Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: CustomElevatedButton(
          icon: Icons.save,
          label: (isAddRoom) ? 'Save' : 'Update',
          backgroundColor: Colors.teal,
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (isAddRoom) {
              roomsController.createNewRoom(context);
            } else {
              roomsController.updateRoom(context, index);
            }
          },
        ),
      );
    }
  }
}
