import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pro/Screen/Reservations/reservations_history.dart';

void main() {
  testWidgets('ReservationsHistoryPage displays empty history',
      (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();
    final List<Map<String, dynamic>> sampleReservations = [];
    for (final reservation in sampleReservations) {
      await firestore
          .collection('users')
          .doc('user_id')
          .collection('reservations')
          .doc()
          .set(reservation);
    }
    await tester.pumpWidget(
      MaterialApp(
        home: ReservationsHistoryPage(sampleReservations),
      ),
    );

    expect(find.text('Booking history is empty!'), findsOneWidget);
    expect(find.text('Reservations history'), findsOneWidget);
  });

  testWidgets('ReservationsHistoryPage displays reservations',
      (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();
    dynamic start1 = Timestamp.fromDate(DateTime.parse('2023-08-05 12:00:00'));
    dynamic end1 = Timestamp.fromDate(DateTime.parse('2023-08-05 15:00:00'));
    dynamic start2 = Timestamp.fromDate(DateTime.parse('2023-09-05 12:00:00'));
    dynamic end2 = Timestamp.fromDate(DateTime.parse('2023-09-05 15:00:00'));

    // Add some fake reservation data to the Firestore instance
    final sampleReservations = [
      {
        'locker': 'Leonardo',
        'cell': 'Cell 0 (small)',
        'reservationStartDate': start1,
        'reservationEndDate': end1,
        'reservationDuration': 2,
        'id': 'mockReservation_1',
      },
      {
        'locker': 'Duomo',
        'cell': 'Cell 0 (small)',
        'reservationStartDate': start2,
        'reservationEndDate': end2,
        'reservationDuration': 2,
        'id': 'mockReservation_2',
      },
    ];

    for (final reservation in sampleReservations) {
      await firestore
          .collection('users')
          .doc('user_id')
          .collection('reservations')
          .doc()
          .set(reservation);
    }
    await tester.pumpWidget(
      MaterialApp(
        home: ReservationsHistoryPage(sampleReservations),
      ),
    );
    // Check if the reservation data is displayed correctly

    expect(find.text('Reservation @ locker Leonardo'), findsOneWidget);
    expect(find.text('Deposited: 05/08/2023, 12:00'), findsOneWidget);
    expect(find.text('Picked-up: 05/08/2023, 15:00'), findsOneWidget);
    expect(find.text('Reservation @ locker Duomo'), findsOneWidget);
    expect(find.text('Deposited: 05/09/2023, 12:00'), findsOneWidget);
    expect(find.text('Picked-up: 05/09/2023, 15:00'), findsOneWidget);
  });
}

// flutter test test/WidgetTests/reservationsHistoryTests/reservations_history_test.dart