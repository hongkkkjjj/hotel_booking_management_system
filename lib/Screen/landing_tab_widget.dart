import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Screen/profile_widget.dart';
import 'package:hotel_booking_management_system/Screen/rooms_widget.dart';

import '../Controller/landing_tab_controller.dart';

class LandingTabScreen extends StatelessWidget {
  final LandingTabController landingTabController =
      Get.find<LandingTabController>();

  LandingTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: _getTabCount(),
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              labelColor: Colors.teal,
              indicatorColor: Colors.teal,
              unselectedLabelColor: Colors.indigo,
              tabs: _buildTabs(),
            ),
            title: const Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: _buildTabViews(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTabs() {
    if (landingTabController.userType.value == UserType.admin) {
      return [
        const Tab(
          icon: Icon(Icons.home),
          text: "Home",
        ),
        const Tab(
          icon: Icon(Icons.local_hotel),
          text: "Rooms",
        ),
        const Tab(
          icon: Icon(Icons.person),
          text: "Profile",
        ),
      ];
    } else {
      return [
        const Tab(
          icon: Icon(Icons.home),
          text: "Home",
        ),
        const Tab(
          icon: Icon(Icons.person),
          text: "Profile",
        ),
      ];
    }
  }

  List<Widget> _buildTabViews() {
    if (landingTabController.userType.value == UserType.admin) {
      return [
        const Icon(Icons.home),
        RoomsScreen(),
        ProfileScreen()
      ];
    } else {
      return [
        const Icon(Icons.home),
        ProfileScreen(),
      ];
    }
  }

  int _getTabCount() {
    return landingTabController.userType.value == UserType.admin ? 3 : 2;
  }
}
