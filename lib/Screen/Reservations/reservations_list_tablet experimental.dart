// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro/Screen/Reservations/reservation_tile_horizontal.dart';
import 'package:pro/Screen/Reservations/reservations_history.dart';
import 'package:pro/Screen/Reservations/reservation_add_tablet.dart';

// A stateful widget representing the bookings page.
class TabletBookingsPage extends StatefulWidget {
  TabletBookingsPage(this.snapshot, {super.key, required this.uid});
  final String uid;
  dynamic snapshot;
  @override
  State<TabletBookingsPage> createState() => _TabletBookingsPageState();
}

class _TabletBookingsPageState extends State<TabletBookingsPage> {
  final GlobalKey<ScaffoldMessengerState> _bookingMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  String selectedLocker = "";
  String selectedCell = "";
  DateTime selectedDropOff = DateTime.now();
  DateTime selectedPickUp = DateTime.now();
  int selectedDuration = 0;
  String selectedReservationId = "";
  String selectedPrice = "";
  bool _tapped = false;

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

      setState(() {
        _tapped = false;
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
              TextButton.icon(
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
                  label: Text("History",
                      style: TextStyle(color: Colors.white, fontSize: 17))),
              TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddBookingTablet(uid: widget.uid)));
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text("Add booking",
                      style: TextStyle(color: Colors.white, fontSize: 17))),
            ],
          ),
          body: widget.snapshot.isEmpty
              ? Center(
                  child:
                      Text("No booking found!", style: TextStyle(fontSize: 20)),
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ListView.builder(
                        itemCount: widget.snapshot.length,
                        itemBuilder: (context, index) {
                          final String locker =
                              widget.snapshot[index]['locker'];
                          final String cell = widget.snapshot[index]['cell'];
                          final DateTime dropOff = widget.snapshot[index]
                                  ['reservationStartDate']
                              .toDate();
                          final DateTime pickUp = widget.snapshot[index]
                                  ['reservationEndDate']
                              .toDate();
                          final String price =
                              widget.snapshot[index]['reservationPrice'];
                          final int duration =
                              widget.snapshot[index]['reservationDuration'];
                          final String reservationId =
                              widget.snapshot[index]['id'];

                          // Create a CustomListItem using the data retrieved from Firestore
                          return ListTile(
                            title: Text("Reservation @ locker $locker",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            subtitle: Text(
                              "from ${DateFormat('dd/MM/yyyy').format(dropOff)}",
                              style: TextStyle(fontSize: 18),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedLocker = locker;
                                selectedCell = cell;
                                selectedDropOff = dropOff;
                                selectedPickUp = pickUp;
                                selectedDuration = duration;
                                selectedReservationId = reservationId;
                                selectedPrice = price;
                                _tapped = true;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                        flex: 6,
                        child: Container(
                            decoration:
                                BoxDecoration(color: Colors.orange[100]),
                            child: _tapped == false
                                ? Center(
                                    child: Text(
                                        "Please tap on a reservation to show details"), //TODO: display app logo instead of text
                                  )
                                : ReservationTileHorizontal(
                                    dropOff: selectedDropOff,
                                    pickUp: selectedPickUp,
                                    locker: selectedLocker,
                                    cell: selectedCell,
                                    duration: selectedDuration,
                                    reservationId: selectedReservationId,
                                    onDelete: () => _deleteReservation(
                                        selectedReservationId,
                                        selectedLocker,
                                        selectedCell),
                                    price: selectedPrice)))
                  ],
                )),
    );
  }
}
