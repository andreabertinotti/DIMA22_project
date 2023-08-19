// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro/Models/user_model.dart';
import 'package:pro/Services/auth_service.dart';
import 'package:provider/provider.dart'; // package used to edit date format
import 'package:pro/Screen/menu.dart';
import 'package:pro/Utils/wrapper.dart';
import 'package:pro/Screen/Reservations/reservation_add.dart';

// A stateful widget representing the bookings page.
class ReservationsHistoryPage extends StatefulWidget {
  const ReservationsHistoryPage({super.key});

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
    required this.baggageSize,
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
  final String baggageSize;
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
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors
                          .red), // TODO: insert locker image or map instead of a solid color
                ),
              ),
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
                      "Cell: $cell (baggage size: $baggageSize)",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Price: ", //€$price",     //TODO:add price
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //ElevatedButton.icon(
              //  // TODO: Open the edit booking page when the button is pressed
              //  onPressed: () {
              //    //Navigator.push(context,MaterialPageRoute(
              //    //builder: (context) => const EditBooking()));
              //  },
              //  icon: Icon(
              //    Icons.edit,
              //    color: Colors.white,
              //  ),
              //  label: Text(
              //    "Edit booking",
              //    style: TextStyle(fontSize: 18, color: Colors.white),
              //  ),
              //  style: ButtonStyle(
              //      foregroundColor:
              //          MaterialStateProperty.all<Color>(Colors.white),
              //      backgroundColor:
              //          MaterialStateProperty.all<Color>(Colors.orange),
              //      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //          RoundedRectangleBorder(
              //              borderRadius: BorderRadius.circular(18),
              //              side: BorderSide(color: Colors.orange)))),
              //),
              //ElevatedButton.icon(
              //  onPressed: onDelete,
              //  //TODO: if notifications are implemented, change delete and notif. buttons --> remove text (only icon buttons)
              //  //onPressed: () {
              //  //  //TODO: Delete booking on button press
              //  //
              //  //},
              //  style: ButtonStyle(
              //      foregroundColor:
              //          MaterialStateProperty.all<Color>(Colors.white),
              //      backgroundColor:
              //          MaterialStateProperty.all<Color>(Colors.orange),
              //      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //          RoundedRectangleBorder(
              //              borderRadius: BorderRadius.circular(18),
              //              side: BorderSide(color: Colors.orange)))),
              //  icon: Icon(Icons.delete, color: Colors.white),
              //  label: Text(
              //    "Delete booking",
              //    style: TextStyle(fontSize: 18, color: Colors.white),
              //  ),
              //),
            ],
          ),
        )
      ],
    );
  }
}

class _ReservationsHistoryPageState extends State<ReservationsHistoryPage> {
  final GlobalKey<ScaffoldMessengerState> _bookingMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  //void _deleteReservation(
  //    String reservationId, User user, String locker, String cell) async {
  //  try {
  //    await FirebaseFirestore.instance
  //        .collection('users')
  //        .doc(user
  //            .uid) // Assuming authService provides the currently logged-in user
  //        .collection('reservations')
  //        .doc(reservationId)
  //        .delete();
//
  //    QuerySnapshot bookedSlotSnapshot = await FirebaseFirestore.instance
  //        .collection('lockers')
  //        .doc(locker)
  //        .collection('cells')
  //        .doc(cell)
  //        .collection('bookedSlots')
  //        .where('linkedReservation', isEqualTo: reservationId)
  //        .get();
//
  //    for (final bookedSlotDoc in bookedSlotSnapshot.docs) {
  //      await bookedSlotDoc.reference.delete();
  //    }
//
  //    // Show a success message using ScaffoldMessenger
  //    _bookingMessengerKey.currentState?.showSnackBar(
  //      SnackBar(content: Text('Reservation deleted successfully')),
  //    );
  //  } catch (error) {
  //    // Show an error message using ScaffoldMessenger
  //    _bookingMessengerKey.currentState?.showSnackBar(
  //      SnackBar(content: Text('Failed to delete reservation')),
  //    );
  //  }
  //}

  void _deleteReservation(
      String reservationId, User user, String locker, String cell) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Delete the reservation document
        final reservationRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('reservations')
            .doc(reservationId);
        transaction.delete(reservationRef);

        // Query and delete the related bookedSlots documents
        final bookedSlotQuery = FirebaseFirestore.instance
            .collection('lockers')
            .doc(locker)
            .collection('cells')
            .doc(cell)
            .collection('bookedSlots')
            .where('linkedReservation', isEqualTo: reservationId);
        final bookedSlotSnapshot = await bookedSlotQuery.get();
        for (final bookedSlotDoc in bookedSlotSnapshot.docs) {
          transaction.delete(bookedSlotDoc.reference);
        }
      });

      // Show a success message using ScaffoldMessenger
      _bookingMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Reservation deleted successfully')),
      );
    } catch (error) {
      // Show an error message using ScaffoldMessenger
      _bookingMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Failed to delete reservation')),
      );
    }
  }

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
                      child: Text("No booking found!",
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
                        final String baggageSize =
                            snapshot.data![index]['baggageSize'];
                        final int duration =
                            snapshot.data![index]['reservationDuration'];
                        final String reservationId =
                            snapshot.data![index]['id'];

                        // Create a CustomListItem using the data retrieved from Firestore
                        return ExpansionTile(
                          title: Text("Reservation @ locker $locker",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          subtitle: Text(
                            "from ${DateFormat('dd/MM/yyyy').format(dropOff)}",
                            style: TextStyle(fontSize: 18),
                          ),
                          textColor: Colors.orange,
                          iconColor: Colors.orange,
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Text(
                              "${index + 1}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          children: <Widget>[
                            CustomListItem(
                              dropOff: dropOff,
                              pickUp: pickUp,
                              baggageSize: baggageSize,
                              duration: duration,
                              cell: cell,
                              locker: locker,
                              reservationId: reservationId,
                              onDelete: () => _deleteReservation(
                                  reservationId,
                                  user,
                                  locker,
                                  cell), // Pass a callback to delete
                              //notificationSet: snapshot.data![index]['notificationSet'],
                              //price: snapshot.data![index]['price'],
                            )
                          ],
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