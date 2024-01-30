import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Controller/trips_controller.dart';
import 'package:hotel_booking_management_system/Screen/booking_widget.dart';
import 'Constant/app_route.dart';
import 'Controller/home_controller.dart';
import 'Controller/landing_tab_controller.dart';
import 'Controller/login_controller.dart';
import 'Controller/profile_controller.dart';
import 'Controller/register_controller.dart';
import 'Controller/rooms_controller.dart';
import 'Screen/add_room_type_widget.dart';
import 'Screen/landing_tab_widget.dart';
import 'Screen/loading_screen.dart';
import 'Screen/login_widget.dart';
import 'Screen/manage_room_widget.dart';
import 'Screen/profile_widget.dart';
import 'Screen/register_widget.dart';
import 'Screen/rooms_widget.dart';
import 'Screen/update_password_widget.dart';
import 'Utils/custom_scroll_behaviour.dart';
import 'Widget/keyboard_dismiss_wrapper.dart';
import 'firebase_options.dart';

// build command
// flutter build web --release --web-renderer html --base-href /hotel-booking/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final List<GetPage> appPages = [
    // Loading
    GetPage(name: Routes.loading, page: () => LoadingScreen()),
    // Login
    GetPage(name: Routes.login, page: () => LoginWidget()),
    GetPage(name: Routes.register, page: () => RegisterScreen()),

    // Landing
    GetPage(name: Routes.home, page: () => LandingTabScreen()),

    // Rooms
    GetPage(name: Routes.rooms, page: () => RoomsScreen()),
    GetPage(name: Routes.addRooms, page: () => AddRoomTypeScreen()),
    GetPage(name: Routes.manageRoom, page: () => ManageRoomScreen()),

    // Booking
    GetPage(name: Routes.booking, page: () => BookingScreen()),

    // Profile
    GetPage(name: Routes.profile, page: () => ProfileScreen()),
    GetPage(name: Routes.updatePassword, page: () => UpdatePasswordScreen()),
  ];

  void putController() {
    Get.put(LoginController());
    Get.put(RegisterController());
    Get.put(LandingTabController());
    Get.put(UserHomeController());
    Get.put(UserController());
    Get.put(RoomsController());
    Get.put(TripsController());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    putController();

    return GetMaterialApp(
      title: 'Flutter Demo',
      initialRoute: Routes.loading,
      debugShowCheckedModeBanner: false,
      getPages: appPages,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: KeyboardDismissWrapper(
        child: LoginWidget(),
      ),
    );
  }

}
