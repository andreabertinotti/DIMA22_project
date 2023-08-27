import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro/Screen/Reservations/reservations_list_tablet%20experimental.dart';
import '../Screen/Reservations/reservations_list_vertical experimental.dart';
import '../Services/database_service.dart';

class ReservationsListWrapper extends StatefulWidget {
  const ReservationsListWrapper({Key? key}) : super(key: key);

  @override
  State<ReservationsListWrapper> createState() =>
      _ReservationsListWrapperState();
}

class _ReservationsListWrapperState extends State<ReservationsListWrapper> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user?.uid == null
          ? Center(
              child: Text("Error loading data."),
            )
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: fetchReservations(user!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error loading data."),
                  );
                } else {
                  return MediaQuery.of(context).size.width < 500
                      ? BookingsPage(snapshot.data!, uid: user!.uid)
                      : TabletBookingsPage(snapshot.data!, uid: user!.uid);
                }
              },
            ),
    );
  }
}
