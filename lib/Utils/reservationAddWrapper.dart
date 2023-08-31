import 'package:flutter/material.dart';
import '../Screen/Reservations/reservation_add.dart';
import '../Services/database_service.dart';

// wrapping a widget: if user is logged in, wrapped widget will be returned, else LoginScreen() will

//Future<List<Map<String, dynamic>>> fetchLockers() async {
//  QuerySnapshot querySnapshot =
//      await FirebaseFirestore.instance.collection('lockers').get();
//
//  List<Map<String, dynamic>> result = [];
//
//  querySnapshot.docs.forEach((DocumentSnapshot doc) {
//    result.add(doc.data() as Map<String, dynamic>);
//  });
//
//  return result;
//}

class ReservationAddWrapper extends StatelessWidget {
  ReservationAddWrapper(this.uid, {Key? key}) : super(key: key);
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
