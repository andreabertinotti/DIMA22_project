import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro/Screen/Reservations/reservations_list_tablet%20experimental.dart';
import 'package:pro/Screen/User/add_profile_screen.dart';

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
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("No booking found!",
                        style: TextStyle(fontSize: 20)),
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
