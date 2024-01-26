import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_management_system/Screen/admin_home_screen.dart';
import 'package:hotel_booking_management_system/Screen/profile_widget.dart';
import 'package:hotel_booking_management_system/Screen/rooms_widget.dart';
import 'package:hotel_booking_management_system/Screen/trips_widget.dart';
import 'package:hotel_booking_management_system/Screen/user_home_screen.dart';

import '../Controller/landing_tab_controller.dart';

class LandingTabScreen extends StatelessWidget {
  final LandingTabController landingTabController =
      Get.find<LandingTabController>();

  LandingTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _getTabCount(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.teal,
          bottom: TabBar(
            labelColor: Colors.indigo,
            indicatorColor: Colors.indigo,
            unselectedLabelColor: Colors.indigo[200],
            tabs: _buildTabs(),
          ),
          title: const Text('Welcome to Hotel Name'),
        ),
        body: TabBarView(
          children: _buildTabViews(),
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
          icon: Icon(Icons.local_hotel),
          text: "Bookings",
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
        AdminHomeScreen(),
        RoomsScreen(),
        ProfileScreen()
      ];
    } else {
      return [
        UserHomeScreen(),
        TripsScreen(),
        ProfileScreen(),
      ];
    }
  }

  int _getTabCount() {
    return landingTabController.userType.value == UserType.admin ? 3 : 3;
  }
}
