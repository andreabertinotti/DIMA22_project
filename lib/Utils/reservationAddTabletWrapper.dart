import 'package:flutter/material.dart';
import 'package:pro/Services/database_service.dart';
import '../Screen/Reservations/reservation_add_tablet experimental.dart';

// wrapping a widget: if user is logged in, wrapped widget will be returned, else LoginScreen() will

class ReservationAddTabletWrapper extends StatelessWidget {
  ReservationAddTabletWrapper(this.uid, {Key? key}) : super(key: key);
  String uid;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchLockers(),
      builder: (context, lockersSnapshot) {
        if (lockersSnapshot.connectionState == ConnectionState.done) {
          if (lockersSnapshot.hasData) {
            final lockersData = lockersSnapshot.data!;
            // Pass userData to Menu widget
            return AddBookingTablet(lockersData, uid: uid);
          } else {
            return const Center(
              child: Text('Error fetching user data'),
            );
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
