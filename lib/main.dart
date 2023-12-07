import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Screen/login_widget.dart';
import 'Widget/keyboard_dismiss_wrapper.dart';
import 'firebase_options.dart';

// build command
// flutter build web --release --web-renderer html --base-href /hotel-booking/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: KeyboardDismissWrapper(
        child: LoginWidget(),
      ),
    );
  }
}
