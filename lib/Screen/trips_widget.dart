import 'package:flutter/material.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Upcoming Trips',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Past Trips',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
