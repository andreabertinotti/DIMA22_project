// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro/Models/user_model.dart';
import 'package:pro/Services/auth_service.dart';
import 'package:provider/provider.dart'; // package used to edit date format

// A stateful widget representing the bookings page.
class ReservationsHistoryPage extends StatefulWidget {
  const ReservationsHistoryPage(this.snapshot, {super.key});

  final dynamic snapshot;

  @override
  State<ReservationsHistoryPage> createState() =>
      _ReservationsHistoryPageState();
}

// A custom list item widget that displays booking information.
class CustomListItem extends StatelessWidget {
  const CustomListItem({
    super.key,
    required this.dropOff,
    required this.pickUp,
    required this.locker,
    required this.cell,
    required this.duration,
    required this.reservationId,
    required this.onDelete,
    //required this.notificationSet,
    //required this.price,
    // required this.lockerImage
  });

  final DateTime dropOff;
  final DateTime pickUp;
  //final String baggageSize;
  final String locker;
  final String cell;
  final int duration;
  final String reservationId;
  final VoidCallback onDelete;
  //final bool notificationSet;
  //final int price;
  // final Widget lockerImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 140,
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // used 'intl' package for date format
                      "Drop-off: ${DateFormat('dd/MM/yyyy, HH:mm').format(dropOff)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      // used 'intl' package for date format
                      "Pick-up: ${DateFormat('dd/MM/yyyy, HH:mm').format(pickUp)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Duration: $duration hours",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    //Text(
                    //  "Baggage size: $baggageSize",
                    //  style: TextStyle(
                    //    fontSize: 18,
                    //  ),
                    //),
                    Text(
                      "Cell: $cell",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    /* Text(
                      "Price: ", //€$price",     //TODO:add price
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ) */
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HistoryListTile extends StatelessWidget {
  const HistoryListTile(
      {super.key,
      required this.dropOff,
      required this.pickUp,
      //required this.baggageSize,
      required this.locker,
      required this.cell,
      required this.duration,
      required this.reservationId,
      required this.onDelete,
      required this.tileIndex});

  final DateTime dropOff;
  final DateTime pickUp;
  //final String baggageSize;
  final String locker;
  final String cell;
  final int duration;
  final String reservationId;
  final VoidCallback onDelete;
  final int tileIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 15, bottom: 15),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  "$tileIndex",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text("Reservation @ locker $locker",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.orange,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 15),
                  child: Text(
                    "Deposited: ${DateFormat('dd/MM/yyyy, HH:mm').format(dropOff)}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 15),
                  child: Text(
                    "Picked-up: ${DateFormat('dd/MM/yyyy, HH:mm').format(pickUp)}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 5, left: 15),
                //   child: Text(
                //     "Baggage size: $baggageSize",
                //     style: TextStyle(fontSize: 16),
                //   ),
                // ),
              ],
            )
          ],
        ));
  }
}

class _ReservationsHistoryPageState extends State<ReservationsHistoryPage> {
  final GlobalKey<ScaffoldMessengerState> _bookingMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<List<Map<String, dynamic>>> fetchReservations(User user) async {
    final DateTime currentTime = DateTime.now();
    //QuerySnapshot reservationSnapshot = await FirebaseFirestore.instance
    //    .collectionGroup('reservations')
    //    .where('userUid', isEqualTo: user.uid)
    //    .get();
    QuerySnapshot reservationSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('reservations')
        .get();

    List<Map<String, dynamic>> reservations = [];

    for (QueryDocumentSnapshot reservationDoc in reservationSnapshot.docs) {
      if (reservationDoc.exists && reservationDoc.data() != null) {
        Map<String, dynamic> reservationData =
            reservationDoc.data()! as Map<String, dynamic>;
        reservationData['id'] =
            reservationDoc.id; // Add the document ID to the map
        reservations.add(reservationData);
      }
    }
    return reservations;
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return ScaffoldMessenger(
            key: _bookingMessengerKey,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                title: const Text(
                  'Reservations history',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                actions: [],
              ),
              body: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchReservations(user!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    print(user.uid);
                    print(snapshot);

                    return Center(
                      child: Text("Error loading data."),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("Booking history is empty!",
                          style: TextStyle(fontSize: 20)),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final String locker = snapshot.data![index]['locker'];
                        final String cell = snapshot.data![index]['cell'];
                        final DateTime dropOff = snapshot.data![index]
                                ['reservationStartDate']
                            .toDate();
                        final DateTime pickUp = snapshot.data![index]
                                ['reservationEndDate']
                            .toDate();
                        //   final String baggageSize =
                        //       snapshot.data![index]['baggageSize'];
                        final int duration =
                            snapshot.data![index]['reservationDuration'];
                        final String reservationId =
                            snapshot.data![index]['id'];

                        // Create a CustomListItem using the data retrieved from Firestore
                        return HistoryListTile(
                          dropOff: dropOff,
                          pickUp: pickUp,
                          //   baggageSize: baggageSize,
                          locker: locker,
                          cell: cell,
                          duration: duration,
                          reservationId: reservationId,
                          onDelete: () {},
                          tileIndex: index + 1,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          );
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
