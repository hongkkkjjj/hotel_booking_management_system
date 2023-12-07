import 'package:get/get.dart';

class RoomsController extends GetxController {
  RxBool sizeType = true.obs;

  void updateSizeTypeValue(bool newValue) {
    sizeType.value = newValue;
  }
}