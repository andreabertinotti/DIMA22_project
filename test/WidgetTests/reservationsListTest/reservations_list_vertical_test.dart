import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pro/Screen/Reservations/reservations_list_vertical%20experimental.dart';

void main() {
  testWidgets('BookingsPage displays reservations',
      (WidgetTester tester) async {
    // Create a fake instance of Cloud Firestore
    final fakeFirestore = FakeFirebaseFirestore();
    dynamic start = Timestamp.fromDate(DateTime.now());
    dynamic end = Timestamp.fromDate(DateTime.now().add(Duration(hours: 3)));
    // Prepare some sample reservation data
    final List<Map<String, dynamic>> sampleReservations = [
      {
        'id': 'reservation1',
        'locker': 'Leonardo',
        'cell': 'Cell 0 (small)',
        'reservationStartDate': start,
        'reservationEndDate': end,
        'reservationPrice': '3€',
        'reservationDuration': 3,
        'lockerAddress': 'via Roma 1, Milano',
      },
      // Add more reservation entries as needed
    ];

    // Add the sample reservation data to the fake Firestore instance
    for (final reservation in sampleReservations) {
      await fakeFirestore
          .collection('users')
          .doc('user_id')
          .collection('reservations')
          .doc(reservation['id'])
          .set(reservation);
    }

    // Build the widget and pass the fake snapshot
    await tester.pumpWidget(
      MaterialApp(
        home: BookingsPage(sampleReservations, uid: 'user_id'),
      ),
    );

    // Expect to find the reservation information in the UI
    expect(find.text('Reservation @ Leonardo'), findsOneWidget);
    expect(find.text('from ${DateFormat('dd/MM/yyyy').format(start.toDate())}'),
        findsOneWidget);
    expect(find.text('Reservation deleted successfully'), findsNothing);

    // Tap on the delete button
    //await tester.tap(find.byIcon(Icons.delete));
    //await tester.pump();
//
    //// Expect to see the success snackbar after deleting
    //expect(find.text('Reservation deleted successfully'), findsOneWidget);
  });

  testWidgets('BookingsPage handles case in which user has no reservations',
      (WidgetTester tester) async {
    // Create a fake instance of Cloud Firestore
    final fakeFirestore = FakeFirebaseFirestore();

    // Prepare some sample reservation data
    final List<Map<String, dynamic>> sampleReservations = [];

    // Add the sample reservation data to the fake Firestore instance
    for (final reservation in sampleReservations) {
      await fakeFirestore
          .collection('users')
          .doc('user_id')
          .collection('reservations')
          .doc(reservation['id'])
          .set(reservation);
    }

    // Build the widget and pass the fake snapshot
    await tester.pumpWidget(
      MaterialApp(
        home: BookingsPage(sampleReservations, uid: 'user_id'),
      ),
    );

    // Expect to find the reservation information in the UI
    expect(find.text('No booking found!'), findsOneWidget);

    // Tap on the delete button
    //await tester.tap(find.byIcon(Icons.delete));
    //await tester.pump();
//
    //// Expect to see the success snackbar after deleting
    //expect(find.text('Reservation deleted successfully'), findsOneWidget);
  });
}

// flutter test test/WidgetTests/reservationsListTest/reservations_list_vertical_test.dart
