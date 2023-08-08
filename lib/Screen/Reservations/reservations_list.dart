// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // package used to edit date format

// A stateful widget representing the bookings page.
class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

// A custom list item widget that displays booking information.
class CustomListItem extends StatelessWidget {
  const CustomListItem({
    super.key,
    required this.dropOff,
    required this.pickUp,
    required this.baggageSize,
    //required this.notificationSet,
    //required this.price,
    // required this.lockerImage
  });

  final DateTime dropOff;
  final DateTime pickUp;
  final String baggageSize;
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
                      "Pick-up: ${DateFormat('dd/MM/yyyy, HH:mm').format(pickUp)}", // TODO: move buttons below the image/text on the tile
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Baggage size: $baggageSize",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    //Text(
                    //  "Price: €$price",
                    //  style: TextStyle(
                    //    fontSize: 18,
                    //    fontWeight: FontWeight.bold,
                    //    color: Colors.orange,
                    //  ),
                    //),
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
              //  // Open the edit booking page when the button is pressed
              //  onPressed: () {
              //    Navigator.push(
              //        context,
              //        MaterialPageRoute(
              //            builder: (context) => const EditBooking()));
              //  },
              //  icon: Icon(Icons.edit),
              //  label: Text("Edit booking"),
              //  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              //),
              //ElevatedButton.icon(
              //  onPressed: () {
              //    // TODO: change booking notification preference (+ notificationSet param)
              //  },
              //  icon: Icon(notificationSet
              //      ? Icons.notifications_off_outlined
              //      : Icons.notifications_active),
              //  label:
              //      Text("Turn ${notificationSet ? "OFF" : "ON"} notification"),
              //  style: ElevatedButton.styleFrom(
              //    backgroundColor: Colors.orange,
              //  ),
              //),
            ],
          ),
        )
      ],
    );
  }
}

class _BookingsPageState extends State<BookingsPage> {
  final GlobalKey<ScaffoldMessengerState> _bookingMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<List<Map<String, dynamic>>> fetchReservations() async {
    // Firestore query to fetch lockers
    QuerySnapshot lockerSnapshot =
        await FirebaseFirestore.instance.collection('lockers').get();

    List<Map<String, dynamic>> reservations = [];

    for (QueryDocumentSnapshot lockerDoc in lockerSnapshot.docs) {
      // Firestore query to fetch cells within the locker
      QuerySnapshot cellSnapshot =
          await lockerDoc.reference.collection('cells').get();

      for (QueryDocumentSnapshot cellDoc in cellSnapshot.docs) {
        // Firestore query to fetch reservations within the cell
        QuerySnapshot reservationSnapshot =
            await cellDoc.reference.collection('reservations').get();

        for (QueryDocumentSnapshot reservationDoc in reservationSnapshot.docs) {
          // Check if the document exists and is not empty
          if (reservationDoc.exists && reservationDoc.data() != null) {
            reservations.add(reservationDoc.data()! as Map<String, dynamic>);
          }
        }
      }
    }

    return reservations;
  }

  ///////////////////////////////////////////////////////////////////////
  /// PROBLEM: avendo inserito prenotazioni fittizie per ogni locker,
  /// vengono tutte contate e l'app cerca di mostrarle, ma siccome hanno i campi vuoti danno un errore.
  /// RISOLVERE INSERENDO SOLO PRENOTAZIONI BEN FORMATE!
  ///
  ///
  ///
  ///

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _bookingMessengerKey,
      child: Scaffold(
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchReservations(),
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
                  // Create a CustomListItem using the data retrieved from Firestore
                  return CustomListItem(
                    dropOff:
                        snapshot.data![index]['reservationStartDate'].toDate(),
                    pickUp:
                        snapshot.data![index]['reservationEndDate'].toDate(),
                    baggageSize: snapshot.data![index]['baggageSize'],
                    //notificationSet: snapshot.data![index]['notificationSet'],
                    //price: snapshot.data![index]['price'],
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
