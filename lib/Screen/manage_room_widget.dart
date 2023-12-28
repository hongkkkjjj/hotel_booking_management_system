import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constant/app_const.dart';
import '../Controller/rooms_controller.dart';

class ManageRoomScreen extends StatelessWidget {
  final RoomsController roomsController = Get.find<RoomsController>();

  ManageRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Manage rooms'),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return ListView.builder(
      itemCount: roomsController.roomList.length,
      itemBuilder: (context, index) {
        var selectedRoom = roomsController.roomList[index];
        var imgList = roomsController.imageUrls[index.toString()] ?? [];
        var imgUrl = imgList.isNotEmpty ? imgList[0] : '';

        return _customCell(
          selectedRoom.title,
          selectedRoom.description,
          selectedRoom.price.toString(),
          imgUrl,
        );
      },
    );
  }

  Widget _customCell(String title, String desc, String price, String imgUrl) {
    print('wow imgUrl is $imgUrl');

    return Card(
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
                    width: kIsWeb ? 300 : 150,
                    height: kIsWeb ? 150 : 75,
                    child: Center(
                      child: CachedNetworkImage(
                        // imageUrl: 'https://firebasestorage.googleapis.com/v0/b/hotel-booking-ee19d.appspot.com/o/images%2F0-0.jpg?alt=media&token=af023714-cb30-4bae-a772-2c733bfa702b',
                        imageUrl: imgUrl,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Container(color: const Color(0xFFCCCCCC)),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )),
            Expanded(
              flex: 4,
              child: _content(
                title,
                desc,
                price,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(String title, String desc, String price) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            'RM $price',
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
