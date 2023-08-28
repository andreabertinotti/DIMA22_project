import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pro/Screen/Reservations/reservation_add experimental.dart';

void main() {
  testWidgets('EditBooking widget loads correctly',
      (WidgetTester tester) async {
    final List<Map<String, dynamic>> sampleLockers = [
      {
        'lockerName': 'Leonardo',
        'lockerAddress': 'Piazza Leonardo da Vinci 32, Milano',
      },
      {
        'lockerName': 'Duomo',
        'lockerAddress': 'Piazza Duomo 21, Milano',
      },
    ];

    await tester.pumpWidget(
        MaterialApp(home: EditBooking(sampleLockers, uid: 'test_uid')));

    // Check if the main components are present
    expect(find.text('Add a new reservation'), findsOneWidget);
    expect(find.text('Locker name:'), findsOneWidget);
    expect(find.text('Drop-off date and time:'), findsOneWidget);
    expect(find.text('Booking duration:'), findsOneWidget);
    expect(find.text('Fill the form'), findsOneWidget);
    expect(find.text('Select available cell:'), findsOneWidget);
    expect(find.text('Price to pay:'), findsOneWidget);
    expect(find.byType(ElevatedButton),
        findsNWidgets(3)); // Save booking and tooltip buttons
  });

  // Write more test cases for different interactions and scenarios
  // testWidgets('Selecting a locker updates available cells',
  //     (WidgetTester tester) async {
  //   final List<Map<String, dynamic>> sampleLockers = [
  //     {
  //       'lockerName': 'Leonardo',
  //       'lockerAddress': 'Piazza Leonardo da Vinci 32, Milano',
  //     },
  //     {
  //       'lockerName': 'Duomo',
  //       'lockerAddress': 'Piazza Duomo 21, Milano',
  //     },
  //   ];
  //   await tester.pumpWidget(
  //       MaterialApp(home: EditBooking(sampleLockers, uid: 'test_uid')));
//
  //   // Select a locker from the dropdown
  //   await tester.tap(find.text('Select a locker'));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.text('Leonardo'));
  //   await tester.pumpAndSettle();
//
  //   // Check if available cell dropdown is updated
  //   expect(find.text('Select available cell:'), findsOneWidget);
//
  //   await tester.tap(find.text('0 hours'));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.text('2 hours'));
  //   await tester.pumpAndSettle();
//
  //   expect(find.text('Check availability'), findsOneWidget);
//
  //   await tester.tap(find.text('Check availability'));
  //   await tester.pumpAndSettle();
  //   //expect(find.text('cell 2 (small)'), findsOneWidget);
  //   //expect(find.text('cell 3 (large)'), findsOneWidget);
  // });

  // Write more test cases to cover other interactions, like selecting cells, date/time changes, etc.

  // Example test for checking availability button behavior
  // testWidgets('Check availability button shows dialog',
  //(WidgetTester tester) async {
  //  final List<Map<String, dynamic>> sampleLockers = [
  //    {
  //      'lockerName': 'Leonardo',
  //      'lockerAddress': 'Piazza Leonardo da Vinci 32, Milano',
  //    },
  //    {
  //      'lockerName': 'Duomo',
  //      'lockerAddress': 'Piazza Duomo 21, Milano',
  //    },
  //  ];
  //  final fakeQuerySnapshot = _createFakeQuerySnapshot(sampleLockers);
  //  await tester.pumpWidget(
  //      MaterialApp(home: EditBooking(sampleLockers, uid: 'test_uid')));
//
  //  // Tap on the "Fill the form" button
  //  await tester.tap(find.text('Fill the form'));
  //  await tester.pumpAndSettle();
//
  //  // TODO: LOGICA PER SELEZIONARE PRIMA LOCKER, DATA E ORA E POI PREMERE CHECK AVAILABILITY
  //};
}

// flutter test test/WidgetTests/reservationAddTests/reservation_add_experimental_test.dart
