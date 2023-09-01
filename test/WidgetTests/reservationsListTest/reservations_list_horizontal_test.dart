import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pro/Screen/Reservations/reservations_list_tablet.dart';

void main() {
  testWidgets('Test TabletBookingsPage with reservations',
      (WidgetTester tester) async {
    final fakeFirestore = FakeFirebaseFirestore();
    dynamic start1 = Timestamp.fromDate(DateTime.parse('2023-08-05 12:00:00'));
    dynamic end1 = Timestamp.fromDate(DateTime.parse('2023-08-05 15:00:00'));
    // Add fake data to the Firestore instance
    final List<Map<String, dynamic>> sampleReservations = [
      {
        'id': 'reserv1',
        'userUid': 'user1',
        'locker': 'Leonardo',
        'cell': 'Cell 0 (small)',
        'reservationStartDate': start1,
        'reservationEndDate': end1,
        'reservationPrice': '3€',
        'reservationDuration': 3,
        'lockerAddress': 'via Roma 1, Milano',
      },
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
        home: TabletBookingsPage(sampleReservations, uid: 'user_id'),
      ),
    );

    // Verify if the "My Reservations" title is displayed
    expect(find.text('My Reservations'), findsOneWidget);
    // expect icon add reservation
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('Add booking'), findsOneWidget);
    // expect icon history
    expect(find.byIcon(Icons.history), findsOneWidget);
    expect(find.text('History'), findsOneWidget);

    expect(find.text('Please tap on a reservation to show details'),
        findsOneWidget);
    expect(
        find.text('from ${DateFormat('dd/MM/yyyy').format(start1.toDate())}'),
        findsOneWidget);
    expect(find.text('Reservation deleted successfully'), findsNothing);

    expect(find.text('Reservation @ locker Leonardo'), findsOneWidget);
  });

  testWidgets('Test TabletBookingsPage widget with no reservation',
      (WidgetTester tester) async {
    final fakeFirestore = FakeFirebaseFirestore();
    // Add fake data to the Firestore instance
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
        home: TabletBookingsPage(sampleReservations, uid: 'user_id'),
      ),
    );

    // Verify if the "My Reservations" title is displayed
    expect(find.text('No booking found!'), findsOneWidget);
  });

  testWidgets("Simulate tap on a reservation", (WidgetTester tester) async {
    final fakeFirestore = FakeFirebaseFirestore();
    dynamic start1 = Timestamp.fromDate(DateTime.parse('2023-10-05 12:00:00'));
    dynamic end1 = Timestamp.fromDate(DateTime.parse('2023-10-05 15:00:00'));
    dynamic start2 = Timestamp.fromDate(DateTime.parse('2023-09-05 12:00:00'));
    dynamic end2 = Timestamp.fromDate(DateTime.parse('2023-09-05 15:00:00'));
    // Add fake data to the Firestore instance
    final List<Map<String, dynamic>> sampleReservations = [
      {
        'id': 'reserv1',
        'userUid': 'user1',
        'locker': 'Leonardo',
        'cell': 'Cell 0 (small)',
        'reservationStartDate': start1,
        'reservationEndDate': end1,
        'reservationPrice': '3€',
        'reservationDuration': 3,
        'lockerAddress': 'via Roma 1, Milano',
      },
      {
        'id': 'reserv2',
        'userUid': 'user1',
        'locker': 'Duomo',
        'cell': 'Cell 0 (small)',
        'reservationStartDate': start2,
        'reservationEndDate': end2,
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
        home: TabletBookingsPage(sampleReservations, uid: 'user_id'),
      ),
    );

    // Simulate tapping on the reservation
    await tester.tap(find.text('Reservation @ locker Leonardo'));
    await tester.pumpAndSettle();
//
    // Verify if the reservation details are displayed

    expect(
        find.text(
            'Drop-off: ${DateFormat('dd/MM/yyyy').format(start1.toDate())}, ${DateFormat('HH:mm').format(start1.toDate())}'),
        findsOneWidget);
    expect(
        find.text(
            'Pick-up: ${DateFormat('dd/MM/yyyy').format(end1.toDate())}, ${DateFormat('HH:mm').format(end1.toDate())}'),
        findsOneWidget);
    expect(find.text('Cell: Cell 0 (small)'), findsOneWidget);
    expect(find.text('Duration: 3 hours'), findsOneWidget);

    expect(find.text('Address: via Roma 1, Milano'), findsOneWidget);
    expect(find.text('Price: 3€'), findsOneWidget);
  });

  testWidgets("Delete booking from list", (WidgetTester tester) async {
    final fakeFirestore = FakeFirebaseFirestore();
    dynamic start1 = Timestamp.fromDate(DateTime.parse('2023-10-05 12:00:00'));
    dynamic end1 = Timestamp.fromDate(DateTime.parse('2023-10-05 15:00:00'));
    dynamic start2 = Timestamp.fromDate(DateTime.parse('2023-09-05 12:00:00'));
    dynamic end2 = Timestamp.fromDate(DateTime.parse('2023-09-05 15:00:00'));
    // Add fake data to the Firestore instance
    final List<Map<String, dynamic>> sampleReservations = [
      {
        'id': 'reserv1',
        'userUid': 'user1',
        'locker': 'Leonardo',
        'cell': 'Cell 0 (small)',
        'reservationStartDate': start1,
        'reservationEndDate': end1,
        'reservationPrice': '3€',
        'reservationDuration': 3,
        'lockerAddress': 'via Roma 1, Milano',
      },
      {
        'id': 'reserv2',
        'userUid': 'user1',
        'locker': 'Duomo',
        'cell': 'Cell 0 (small)',
        'reservationStartDate': start2,
        'reservationEndDate': end2,
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
        home: TabletBookingsPage(sampleReservations, uid: 'user_id'),
      ),
    );

    // Simulate tapping on the reservation
    await tester.tap(find.text('Reservation @ locker Leonardo'));
    await tester.pumpAndSettle();

    // simulate tap on delete booking
    await tester.tap(find.text('Delete booking'));
    await tester.pumpAndSettle();

    // Tap on the delete button
    //await tester.tap(find.byIcon(Icons.delete));
    //await tester.pump();
//
    // Expect to see the success snackbar after deleting
    expect(find.byType(SnackBar), findsOneWidget);
    // reservations can't actually be deleted because there cannot be interaction with firestore
    expect(find.text('Failed to delete reservation'), findsOneWidget);
    //expect(find.text('Reservation deleted successfully'), findsOneWidget);
  });
}


// flutter test test/WidgetTests/reservationsListTest/reservations_list_horizontal_test.dart
