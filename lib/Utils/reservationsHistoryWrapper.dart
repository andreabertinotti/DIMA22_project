import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screen/Reservations/reservations_history.dart';
import '../Services/database_service.dart';

class ReservationsHistoryWrapper extends StatefulWidget {
  const ReservationsHistoryWrapper({Key? key}) : super(key: key);

  @override
  State<ReservationsHistoryWrapper> createState() =>
      _ReservationsHistoryWrapperState();
}

class _ReservationsHistoryWrapperState
    extends State<ReservationsHistoryWrapper> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user?.uid == null
          ? Center(
              child: Text("Error loading data."),
            )
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: fetchReservationsHistory(user!.uid),
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
                  return ReservationsHistoryPage(snapshot.data!);
                }
              },
            ),
    );
  }
}
