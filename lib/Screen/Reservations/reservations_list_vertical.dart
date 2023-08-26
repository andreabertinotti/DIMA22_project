// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro/Screen/Reservations/reservation_tile_vertical.dart';
import 'package:pro/Screen/Reservations/reservations_history.dart';
import 'package:pro/Screen/Reservations/reservation_add.dart';

// A stateful widget representing the bookings page.
class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key, required this.uid});
  final String uid;
  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final GlobalKey<ScaffoldMessengerState> _bookingMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void _deleteReservation(
      String reservationId, String locker, String cell) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Delete the reservation document
        final reservationRef = FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
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

  Stream<List<Map<String, dynamic>>> fetchReservationsLive() {
    final DateTime currentTime = DateTime.now();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('reservations')
        .where('reservationEndDate',
            isGreaterThan: Timestamp.fromDate(currentTime))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((reservationDoc) {
        Map<String, dynamic> reservationData =
            reservationDoc.data()! as Map<String, dynamic>;
        reservationData['id'] = reservationDoc.id;
        return reservationData;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _bookingMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          title: const Text(
            'My Reservations',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReservationsHistoryPage()));
              },
              icon: Icon(
                Icons.history,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditBooking(uid: widget.uid)));
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: fetchReservationsLive(),
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
                child:
                    Text("No booking found!", style: TextStyle(fontSize: 20)),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final String locker = snapshot.data![index]['locker'];
                  final String cell = snapshot.data![index]['cell'];
                  final DateTime dropOff =
                      snapshot.data![index]['reservationStartDate'].toDate();
                  final DateTime pickUp =
                      snapshot.data![index]['reservationEndDate'].toDate();
                  final String price =
                      snapshot.data![index]['reservationPrice'];
                  final int duration =
                      snapshot.data![index]['reservationDuration'];
                  final String reservationId = snapshot.data![index]['id'];

                  // Create a CustomListItem using the data retrieved from Firestore
                  return ExpansionTile(
                    title: Text("Reservation @ $locker",
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
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    children: <Widget>[
                      ReservationTileVertical(
                        dropOff: dropOff,
                        pickUp: pickUp,
                        duration: duration,
                        cell: cell,
                        locker: locker,
                        reservationId: reservationId,
                        price: price,
                        onDelete: () => _deleteReservation(reservationId,
                            locker, cell), // Pass a callback to delete
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
  }
}
