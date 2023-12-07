import 'package:calendar_view/calendar_view.dart';
import 'package:get/get.dart';

class RoomsController extends GetxController {
  RxBool sizeType = true.obs;
  EventController eventController = EventController();
  List<CalendarEventData> eventList = <CalendarEventData>[].obs;

  void updateSizeTypeValue(bool newValue) {
    sizeType.value = newValue;
  }

  void addCalendarEvent(List<CalendarEventData> list) {
    eventList = list;
    eventController.addAll(list);
  }
}