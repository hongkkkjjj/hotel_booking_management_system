import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Controller/home_controller.dart';
import 'package:hotel_booking_management_system/Structs/enums.dart';

import '../Constant/app_const.dart';
import '../Constant/app_route.dart';
import '../Controller/landing_tab_controller.dart';
import '../Controller/rooms_controller.dart';

class ManageRoomScreen extends StatelessWidget {
  final RoomsController roomsController = Get.find<RoomsController>();
  final LandingTabController landingTabController =
      Get.find<LandingTabController>();
  final UserHomeController userHomeController = Get.find<UserHomeController>();

  ManageRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text((roomsController.isSearch) ? 'Rooms' : 'Manage rooms'),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: kWebWidth),
        child: ListView.builder(
          itemCount: roomsController.isSearch
              ? roomsController.searchRoomList.length
              : roomsController.roomList.length,
          itemBuilder: (context, index) {
            var selectedRoom = roomsController.isSearch
                ? roomsController.searchRoomList[index]
                : roomsController.roomList[index];
            var imgList = roomsController.imageUrls[index.toString()] ?? [];
            var imgUrl = imgList.isNotEmpty ? imgList[0] : '';

            return _customCell(
              index,
              selectedRoom.title,
              selectedRoom.description,
              selectedRoom.price.toString(),
              imgUrl,
            );
          },
        ),
      ),
    );
  }

  Widget _customCell(
      int index, String title, String desc, String price, String imgUrl) {
    return InkWell(
      onTap: () {
        if (landingTabController.userType.value == UserType.guest) {
          roomsController.addRoomScreenType = AddRoomScreenType.View;
        } else {
          roomsController.addRoomScreenType = AddRoomScreenType.Edit;
        }
        userHomeController.roomSequence = index;
        Get.toNamed(Routes.addRooms);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: kIsWeb ? 400 : 150,
                      height: kIsWeb ? 200 : 75,
                      child: (imgUrl.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: imgUrl,
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
                            )
                          : Image.asset(
                              'assets/images/img_no_img.png',
                              fit: BoxFit.fill,
                            ),
                    ),
                  )),
              Expanded(
                flex: 4,
                child: roomsController.isSearch
                    ? _searchContent(title, desc, price)
                    : _content(index, title, desc, price),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(int index, String title, String desc, String price) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            desc,
            style: const TextStyle(fontSize: 12.0),
            maxLines: 3,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Text(
            'RM$price night',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchContent(String title, String desc, String price) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            desc,
            style: const TextStyle(fontSize: 12.0),
            maxLines: 3,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Text(
            'RM$price night',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
          ),
          Text(
            'RM${int.parse(price) * roomsController.searchDuration} total',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
