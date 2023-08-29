import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pro/Screen/Reservations/reservation_add_locker.dart';

void main() {
  testWidgets('EditBooking widget loads correctly',
      (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('lockers').doc('Leonardo').set({
      'lockerName': 'Leonardo',
      'lockerAddress': 'via Roma 1, Milano',
    });
    final document =
        await firestore.collection('lockers').doc('Leonardo').get();
    await tester.pumpWidget(
        MaterialApp(home: EditLockerBooking(document, uid: 'test_uid')));

    // Check if the main components are present
    expect(find.text('Add a new reservation'), findsOneWidget);
    expect(find.text('Locker name:'), findsOneWidget);
    expect(find.text('Drop-off date and time:'), findsOneWidget);
    expect(find.text('Booking duration:'), findsOneWidget);
    expect(find.text('Fill the form'), findsOneWidget);
    expect(find.text('Select available cell:'), findsOneWidget);
    expect(find.text('Price to pay:'), findsOneWidget);
    expect(find.text('Locker Address:'), findsOneWidget);
    expect(
        find.byType(ElevatedButton),
        findsNWidgets(
            4)); // Save booking and tooltip buttons + pre-selected locker button
  });

  testWidgets('User tries to check availability without selecting a locker',
      (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('lockers').doc('Leonardo').set({
      'lockerName': 'Leonardo',
      'lockerAddress': 'via Roma 1, Milano',
    });
    final document =
        await firestore.collection('lockers').doc('Leonardo').get();
    await tester.pumpWidget(
        MaterialApp(home: EditLockerBooking(document, uid: 'test_uid')));

    // Tap the button for checking availability without having selected a locker
    await tester.tap(find.text('Fill the form'));
    await tester.pumpAndSettle();

    // Verify that the AlertDialog is shown
    expect(find.byType(AlertDialog), findsOneWidget);
    // Verify that the title text is present
    expect(find.text('Please fill the information above'), findsOneWidget);
    expect(
        find.text(
            'You need to select the date and a valid duration before checking availability.'),
        findsOneWidget);
  });

  testWidgets(
      'User tries to check availability with duration left to 0 (Fill the form is displayed instead of check availability)',
      (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('lockers').doc('Leonardo').set({
      'lockerName': 'Leonardo',
      'lockerAddress': 'via Roma 1, Milano',
    });
    final document =
        await firestore.collection('lockers').doc('Leonardo').get();
    await tester.pumpWidget(
        MaterialApp(home: EditLockerBooking(document, uid: 'test_uid')));

// Tap the button for checking availability without having selected a locker
    await tester.tap(find.text('Fill the form'));
    await tester.pumpAndSettle();

    // Verify that the AlertDialog is shown
    expect(find.byType(AlertDialog), findsOneWidget);
    // Verify that the title text is present
    expect(find.text('Please fill the information above'), findsOneWidget);
    expect(
        find.text(
            'You need to select the date and a valid duration before checking availability.'),
        findsOneWidget);
  });

  testWidgets(
      'User selects a locker, a time, and a duration and button check availability is displayed',
      (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('lockers').doc('Leonardo').set({
      'lockerName': 'Leonardo',
      'lockerAddress': 'via Roma 1, Milano',
    });
    final document =
        await firestore.collection('lockers').doc('Leonardo').get();
    await tester.pumpWidget(
        MaterialApp(home: EditLockerBooking(document, uid: 'test_uid')));

    // select a time from the dropdown
    await tester.tap(find.text('12'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('10'));
    await tester.pumpAndSettle();

// select a duration from the dropdown
    await tester.tap(find.text('0 hours'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2 hours'));
    await tester.pumpAndSettle();

    expect(find.text('Check availability'), findsOneWidget);

    await tester.tap(find.text('Check availability'));
    await tester.pumpAndSettle();
    //expect(find.text('cell 2 (small)'), findsOneWidget);
    //expect(find.text('cell 3 (large)'), findsOneWidget);
  });

  testWidgets('Check dialog box for reservation in the past',
      (WidgetTester tester) async {
    dynamic now = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('lockers').doc('Leonardo').set({
      'lockerName': 'Leonardo',
      'lockerAddress': 'via Roma 1, Milano',
    });
    final document =
        await firestore.collection('lockers').doc('Leonardo').get();
    await tester.pumpWidget(
        MaterialApp(home: EditLockerBooking(document, uid: 'test_uid')));

    // select a future date from the calendar widget
    await tester.tap(find.text(now));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // select a time from the dropdown
    await tester.tap(find.text('12'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('09'));
    await tester.pumpAndSettle();

// select a duration from the dropdown
    await tester.tap(find.text('0 hours'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2 hours'));
    await tester.pumpAndSettle();

    expect(find.text('Check availability'), findsOneWidget);

    await tester.tap(find.text('Check availability'));
    await tester.pumpAndSettle();
    // Verify that the AlertDialog is shown
    expect(find.byType(AlertDialog), findsOneWidget);
    // Verify that the title text is present
    expect(find.text('Invalid Date'), findsOneWidget);
    expect(find.text('You can\'t make a reservation in the past!'),
        findsOneWidget);
  });

  testWidgets('Check dialog box for reservation in the future',
      (WidgetTester tester) async {
    dynamic now = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('lockers').doc('Leonardo').set({
      'lockerName': 'Leonardo',
      'lockerAddress': 'via Roma 1, Milano',
    });
    final document =
        await firestore.collection('lockers').doc('Leonardo').get();
    await tester.pumpWidget(
        MaterialApp(home: EditLockerBooking(document, uid: 'test_uid')));

    // select a future date from the calendar widget
    await tester.tap(find.text(now));
    await tester.pumpAndSettle();
    // set a date in the future
    await tester.tap(find.text('31'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // select a time from the dropdown
    await tester.tap(find.text('12'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('11'));
    await tester.pumpAndSettle();

// select a duration from the dropdown
    await tester.tap(find.text('0 hours'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2 hours'));
    await tester.pumpAndSettle();

    expect(find.text('Check availability'), findsOneWidget);

    await tester.tap(find.text('Check availability'));
    await tester.pumpAndSettle();
    // Verify that the AlertDialog is shown
    expect(find.byType(AlertDialog), findsOneWidget);
    // Verify that the title text is present
    //expect(find.text('Check availability'), findsOneWidget);
    expect(
        find.text(
            'Do you want to check for availability in the selected date and locker?'),
        findsOneWidget);
  });
}

// flutter test test/WidgetTests/reservationAddTests/reservation_add_locker_test.dart
