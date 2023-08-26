import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pro/Screen/Reservations/reservations_list.dart';

// Import your BookingsPage widget

void main() {
  group('BookingsPage Widget Tests', () {
    // Create an instance of FakeFirebaseFirestore
    final fakeFirestore = FakeFirebaseFirestore();

    // Helper function to build the widget
    Future<void> _buildBookingsPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BookingsPage(uid: 'testUserId'), // Provide a test user ID
        ),
      );
      await tester.pumpAndSettle();
    }

    setUp(() async {
      // Set the Firestore instance to the fake instance

      // Add your mock data to the fake instance
      final collectionReference =
          fakeFirestore.collection('users/testUserId/reservations');
      await collectionReference.add({
        'locker': 'Locker 1',
        'cell': 'Cell 1',
        'reservationStartDate': FieldValue.serverTimestamp(),
        'reservationEndDate': FieldValue.serverTimestamp(),
        'reservationDuration': 2,
        'id': '1',
      });

      await collectionReference.add({
        'locker': 'Locker 2',
        'cell': 'Cell 2',
        'reservationStartDate': FieldValue.serverTimestamp(),
        'reservationEndDate': FieldValue.serverTimestamp(),
        'reservationDuration': 3,
        'id': '2',
      });
    });

    testWidgets('Widget builds and displays booking items',
        (WidgetTester tester) async {
      await _buildBookingsPage(tester);

      expect(find.byType(ExpansionTile),
          findsNWidgets(2)); // Adjust the count as needed
    });

    // Add more test scenarios as needed
  });
}



//'2023-09-03 15:00:00'
//flutter test test/WidgetTests/reservations_list_test.dart