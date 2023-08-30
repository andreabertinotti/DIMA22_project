// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro/Models/user_model.dart';

// A stateful widget representing the bookings page.
class ReservationsHistoryPage extends StatefulWidget {
  const ReservationsHistoryPage(this.snapshot, {super.key});

  final dynamic snapshot;

  @override
  State<ReservationsHistoryPage> createState() =>
      _ReservationsHistoryPageState();
}

class HistoryListTile extends StatelessWidget {
  const HistoryListTile(
      {super.key,
      required this.dropOff,
      required this.pickUp,
      required this.locker,
      required this.cell,
      required this.duration,
      required this.reservationId,
      required this.onDelete,
      required this.tileIndex});

  final DateTime dropOff;
  final DateTime pickUp;

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
              ],
            )
          ],
        ));
  }
}

class _ReservationsHistoryPageState extends State<ReservationsHistoryPage> {
  final GlobalKey<ScaffoldMessengerState> _bookingMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
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
          body: widget.snapshot.isEmpty
              ? Center(
                  child: Text("Booking history is empty!",
                      style: TextStyle(fontSize: 20)),
                )
              : ListView.builder(
                  itemCount: widget.snapshot.length,
                  itemBuilder: (context, index) {
                    final String locker = widget.snapshot[index]['locker'];
                    final String cell = widget.snapshot[index]['cell'];
                    final DateTime dropOff =
                        widget.snapshot[index]['reservationStartDate'].toDate();
                    final DateTime pickUp =
                        widget.snapshot[index]['reservationEndDate'].toDate();

                    final int duration =
                        widget.snapshot[index]['reservationDuration'];
                    final String reservationId = widget.snapshot[index]['id'];

                    return HistoryListTile(
                      dropOff: dropOff,
                      pickUp: pickUp,
                      locker: locker,
                      cell: cell,
                      duration: duration,
                      reservationId: reservationId,
                      onDelete: () {},
                      tileIndex: index + 1,
                    );
                  },
                )),
    );
  }
}
