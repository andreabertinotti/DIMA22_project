import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pro/Screen/Reservations/reservations_list.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
  });

  testWidgets('BookingsPage displays reservations',
      (WidgetTester tester) async {
    // Add a fake reservation document to the fake Firestore instance
    final reservationData = {
      'locker': 'Locker 1',
      'cell': 'Cell 1',
      'reservationStartDate': DateTime.now(),
      'reservationEndDate': DateTime.now(),
      'reservationDuration': 2,
      'id': '1',
    };
    await fakeFirestore
        .collection('users')
        .doc('testUserId')
        .collection('reservations')
        .add(reservationData);

    // Build the widget and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: BookingsPage(uid: 'testUserId'),
      ),
    );

    // Verify that the reservation information is displayed
    expect(find.text("Reservation @ Locker 1"), findsOneWidget);
    expect(find.text("from ${DateFormat('dd/MM/yyyy').format(DateTime.now())}"),
        findsOneWidget);
    expect(find.text("Duration: 2 hours"), findsOneWidget);
    expect(find.text("Cell: Cell 1"), findsOneWidget);

    // Perform actions or additional assertions as needed
  });
}

// flutter test test/WidgetTests/reservations_list_test2.dart