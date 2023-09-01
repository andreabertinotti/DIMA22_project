import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pro/Screen/Reservations/reservation_add_tablet.dart';

void main() {
  testWidgets('HORIZONTAL AddBookingTablet widget loads correctly',
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
        MaterialApp(home: AddBookingTablet(sampleLockers, uid: 'test_uid')));

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
    expect(find.text('SAVE BOOKING'), findsOneWidget);
  });

  testWidgets('HORIZONTAL Info tooltip works correctly',
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
        MaterialApp(home: AddBookingTablet(sampleLockers, uid: 'test_uid')));

    expect(find.byType(Tooltip), findsOneWidget);
    expect(find.text('?'), findsOneWidget);

    // Tap the button for checking availability without having selected a locker
    await tester.tap(find.text('?'));
    await tester.pumpAndSettle();

    // Verify that the title text is present
    expect(
        find.text(
            '\nSmall cells can store baggages up to:\n60x40x25 cm\n\nLarge cells can store baggages up to:\n80x55x40 cm\n\nDimensions are intended as:\nHEIGHT x WIDTH x DEPTH\n'),
        findsOneWidget);
  });

  testWidgets(
      'HORIZONTAL User tries to save booking without selecting a locker',
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
        MaterialApp(home: AddBookingTablet(sampleLockers, uid: 'test_uid')));

    // Tap the button for checking availability without having selected a locker
    await tester.tap(find.text('SAVE BOOKING'));
    await tester.pumpAndSettle();

    // Verify that the AlertDialog is shown
    expect(find.byType(SnackBar), findsOneWidget);
    // Verify that the title text is present
    expect(find.text('Please select a locker'), findsOneWidget);
  });

  testWidgets(
      'HORIZONTAL User tries to save booking after selecting a locker without filling information',
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
        MaterialApp(home: AddBookingTablet(sampleLockers, uid: 'test_uid')));

    // Select a locker from the dropdown
    await tester.tap(find.text('Select a locker'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leonardo'));
    await tester.pumpAndSettle();

    // Tap the button for checking availability without having selected a locker
    await tester.tap(find.text('SAVE BOOKING'));
    await tester.pumpAndSettle();

    // Verify that the AlertDialog is shown
    expect(find.byType(SnackBar), findsOneWidget);
    // Verify that the title text is present
    expect(find.text('Please complete your reservation before saving it'),
        findsOneWidget);
  });

  testWidgets(
      'HORIZONTAL User tries to check availability without selecting a locker',
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
        MaterialApp(home: AddBookingTablet(sampleLockers, uid: 'test_uid')));

    // Tap the button for checking availability without having selected a locker
    await tester.tap(find.text('Fill the form'));
    await tester.pumpAndSettle();

    // Verify that the AlertDialog is shown
    expect(find.byType(AlertDialog), findsOneWidget);
    // Verify that the title text is present
    expect(find.text('Please fill the information above'), findsOneWidget);
    expect(
        find.text(
            'You need to select the locker, date and a valid duration before checking availability.'),
        findsOneWidget);
  });

  testWidgets(
      'HORIZONTAL User tries to check availability with a locker selected but duration left to 0 (Fill the form is displayed instead of check availability)',
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
        MaterialApp(home: AddBookingTablet(sampleLockers, uid: 'test_uid')));

    //Select a locker from the dropdown
    await tester.tap(find.text('Select a locker'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leonardo'));
    await tester.pumpAndSettle();

    //Tap the button for checking availability without having selected a locker
    await tester.tap(find.text('Fill the form'));
    await tester.pumpAndSettle();

    // Verify that the AlertDialog is shown
    expect(find.byType(AlertDialog), findsOneWidget);
    // Verify that the title text is present
    expect(find.text('Please fill the information above'), findsOneWidget);
    expect(
        find.text(
            'You need to select the locker, date and a valid duration before checking availability.'),
        findsOneWidget);
  });

  testWidgets(
      'HORIZONTAL User selects a locker, a time, and a duration and button check availability is displayed',
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
        MaterialApp(home: AddBookingTablet(sampleLockers, uid: 'test_uid')));

    // Select a locker from the dropdown
    await tester.tap(find.text('Select a locker'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leonardo'));
    await tester.pumpAndSettle();

    // select a time from the dropdown
    await tester.tap(find.text('12'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('10'));
    await tester.pumpAndSettle();

    //select a duration from the dropdown
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

  testWidgets('HORIZONTAL Check dialog box for reservation in the past',
      (WidgetTester tester) async {
    dynamic now = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    final currentMonth = DateFormat.MMMM().format(DateTime.now());
    final currentYear = DateTime.now().year;
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
        MaterialApp(home: AddBookingTablet(sampleLockers, uid: 'test_uid')));

    // Select a locker from the dropdown
    await tester.tap(find.text('Select a locker'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leonardo'));
    await tester.pumpAndSettle();

    // select a future date from the calendar widget
    await tester.tap(find.text(now));
    await tester.pumpAndSettle();
    await tester.tap(find.text('$currentMonth $currentYear'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2022'));
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

    //select a duration from the dropdown
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

  testWidgets('HORIZONTAL Check dialog box for reservation in the future',
      (WidgetTester tester) async {
    dynamic now = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    final currentMonth = DateFormat.MMMM().format(DateTime.now());
    final currentYear = DateTime.now().year;
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
        MaterialApp(home: AddBookingTablet(sampleLockers, uid: 'test_uid')));

    // Select a locker from the dropdown
    await tester.tap(find.text('Select a locker'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leonardo'));
    await tester.pumpAndSettle();

    // select a future date from the calendar widget
    await tester.tap(find.text(now));
    await tester.pumpAndSettle();
    // set a date in the future
    await tester.tap(find.text('$currentMonth $currentYear'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2025'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('27'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // select a time from the dropdown
    await tester.tap(find.text('12'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('11'));
    await tester.pumpAndSettle();

    //select a duration from the dropdown
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

// flutter test test/WidgetTests/reservationAddTests/reservation_add_tablet_test.dart