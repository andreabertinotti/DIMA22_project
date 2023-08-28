import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Screen/Reservations/reservation_add copy.dart';

// wrapping a widget: if user is logged in, wrapped widget will be returned, else LoginScreen() will

class ReservationAddWrapper extends StatelessWidget {
  ReservationAddWrapper(this.uid, {Key? key}) : super(key: key);
  String uid;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('lockers').get(),
      builder: (context, lockersSnapshot) {
        if (lockersSnapshot.connectionState == ConnectionState.done) {
          if (lockersSnapshot.hasData) {
            final lockersData = lockersSnapshot.data!;
            // Pass userData to Menu widget
            return EditBooking(lockersData, uid: uid);
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
