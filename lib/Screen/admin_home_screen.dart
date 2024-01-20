import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: kIsWeb ? 32 : 16,
          horizontal: kIsWeb ? 32 : 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Chip(label: Text('Today\'s bookings')),
            Chip(label: Text('Upcoming\'s bookings')),
          ],
        ),
      ),
    );
  }
}
