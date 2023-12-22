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
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: kWebWidth),
          child: ListView(
            children: List.generate(
              10,
              // (index) => _roomCell(),
              (index) => _customCell(
                'Single Room',
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ornare lectus vel lacus bibendum, sit amet sollicitudin ex faucibus. Curabitur blandit consequat lorem nec facilisis. Vivamus mi quam, vehicula id viverra sit amet, gravida et risus. Phasellus condimentum faucibus efficitur. Pellentesque tincidunt purus nec magna elementum faucibus. Etiam sollicitudin rutrum tellus nec rutrum. Suspendisse et placerat elit. Aliquam id mollis leo, eget cursus ligula. Nam eget massa risus. Phasellus volutpat mauris et neque vulputate, ut vehicula neque dapibus.\n\nInteger at ultricies massa. Vivamus volutpat, ligula eget iaculis iaculis, urna orci egestas nunc, eget placerat mauris eros id velit. Donec neque dolor, ultrices nec ornare sit amet, eleifend vitae sapien. Mauris vitae malesuada neque. Aliquam sed hendrerit orci, non hendrerit metus. Maecenas ultrices dui vitae commodo dignissim. Nam in tellus sapien. Vestibulum vel congue risus. Cras efficitur tristique neque, ac porttitor velit. Vestibulum eget tristique turpis. Nam tincidunt est at erat dignissim, at porta sem iaculis. Nunc consectetur porta est, quis viverra augue vulputate ut. Nullam a ornare sem, sed vehicula orci. Sed at turpis accumsan, rutrum felis nec, sagittis dui. Phasellus a mauris metus.\n\nIn iaculis sapien non lectus venenatis, vitae varius lorem mollis. Morbi non eleifend felis, non lobortis tellus. Quisque in gravida velit, id volutpat orci. Proin hendrerit, diam et consectetur aliquet, velit erat mattis nisl, vitae condimentum eros dui ornare urna. Ut at mattis ante, id sollicitudin urna. Curabitur nunc diam, porttitor sed imperdiet eu, vehicula condimentum odio. Curabitur id sem nec purus gravida auctor at nec quam. Integer lacinia nunc vel tempor imperdiet. In ante nisl, pulvinar ultricies massa id, dapibus elementum est. Sed posuere consectetur dui, pharetra lobortis magna laoreet quis. Maecenas ut varius orci, ac dignissim odio. Nulla volutpat non elit in feugiat. Donec magna diam, pharetra in fermentum blandit, iaculis non nulla.',
                '250'
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roomCell() {
    return const Card(
      child: ListTile(
        leading: FlutterLogo(
          size: 72.0,
        ),
        title: Text('Single room'),
        subtitle: Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ornare lectus vel lacus bibendum, sit amet sollicitudin ex faucibus. Curabitur blandit consequat lorem nec facilisis. Vivamus mi quam, vehicula id viverra sit amet, gravida et risus. Phasellus condimentum faucibus efficitur. Pellentesque tincidunt purus nec magna elementum faucibus. Etiam sollicitudin rutrum tellus nec rutrum. Suspendisse et placerat elit. Aliquam id mollis leo, eget cursus ligula. Nam eget massa risus. Phasellus volutpat mauris et neque vulputate, ut vehicula neque dapibus.\n\nInteger at ultricies massa. Vivamus volutpat, ligula eget iaculis iaculis, urna orci egestas nunc, eget placerat mauris eros id velit. Donec neque dolor, ultrices nec ornare sit amet, eleifend vitae sapien. Mauris vitae malesuada neque. Aliquam sed hendrerit orci, non hendrerit metus. Maecenas ultrices dui vitae commodo dignissim. Nam in tellus sapien. Vestibulum vel congue risus. Cras efficitur tristique neque, ac porttitor velit. Vestibulum eget tristique turpis. Nam tincidunt est at erat dignissim, at porta sem iaculis. Nunc consectetur porta est, quis viverra augue vulputate ut. Nullam a ornare sem, sed vehicula orci. Sed at turpis accumsan, rutrum felis nec, sagittis dui. Phasellus a mauris metus.\n\nIn iaculis sapien non lectus venenatis, vitae varius lorem mollis. Morbi non eleifend felis, non lobortis tellus. Quisque in gravida velit, id volutpat orci. Proin hendrerit, diam et consectetur aliquet, velit erat mattis nisl, vitae condimentum eros dui ornare urna. Ut at mattis ante, id sollicitudin urna. Curabitur nunc diam, porttitor sed imperdiet eu, vehicula condimentum odio. Curabitur id sem nec purus gravida auctor at nec quam. Integer lacinia nunc vel tempor imperdiet. In ante nisl, pulvinar ultricies massa id, dapibus elementum est. Sed posuere consectetur dui, pharetra lobortis magna laoreet quis. Maecenas ut varius orci, ac dignissim odio. Nulla volutpat non elit in feugiat. Donec magna diam, pharetra in fermentum blandit, iaculis non nulla.',
          maxLines: 3,
        ),
      ),
    );
  }

  Widget _customCell(String title, String desc, String price) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              flex: 2,
              child: FlutterLogo(
                size: 72.0,
              ),
            ),
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
