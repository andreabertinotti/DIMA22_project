import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pro/Screen/User/add_profile_screen.dart';

void main() {
  testWidgets('AddProfile widget test', (WidgetTester tester) async {
    // Provide sample uid and email for testing
    final String uid = 'test_uid';
    final String email = 'test@example.com';

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: AddProfile(uid, email), // Pass the uid and email
      ),
    );

    // Verify that the widget is rendered with the correct data.
    expect(find.text('Complete your profile'), findsOneWidget);
    expect(find.text('Insert your name'), findsOneWidget);
    expect(find.text('Insert your surname'), findsOneWidget);
    expect(find.text('Update phone number'), findsOneWidget);
    expect(find.text('Insert your address'), findsOneWidget);

    // Simulate filling in the form fields
    await tester.enterText(
        find.widgetWithText(TextField, 'Insert your name'), 'Mario');
    await tester.enterText(
        find.widgetWithText(TextField, 'Insert your surname'), 'Rossi');
    await tester.enterText(
        find.widgetWithText(TextField, 'Update phone number'), '1234567890');
    await tester.enterText(
        find.widgetWithText(TextField, 'Insert your address'),
        'viale Roma 12, Milano');

    // Tap the Save button
    await tester.tap(find.text('SAVE'));
    await tester.pumpAndSettle();
  });

  testWidgets('AddProfile: user provides too short name',
      (WidgetTester tester) async {
    // Provide sample uid and email for testing
    final String uid = 'test_uid';
    final String email = 'test@example.com';

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: AddProfile(uid, email), // Pass the uid and email
      ),
    );

    // Simulate filling in the form fields
    await tester.enterText(
        find.widgetWithText(TextField, 'Insert your name'), 'M');
    await tester.enterText(
        find.widgetWithText(TextField, 'Insert your surname'), 'Rossi');
    await tester.enterText(
        find.widgetWithText(TextField, 'Update phone number'), '1234567890');
    await tester.enterText(
        find.widgetWithText(TextField, 'Insert your address'),
        'viale Roma 12, Milano');

    // Tap the Save button
    await tester.tap(find.text('SAVE'));
    await tester.pumpAndSettle();

    //TODO: UPDATE MISSING NAME WITH NEW MESSAGE
    expect(find.text('Missing name'), findsOneWidget);
    expect(find.text('Error!'), findsOneWidget);
    expect(find.text('Please check the inserted values!'), findsOneWidget);
  });

  testWidgets('AddProfile: user provides too short name',
      (WidgetTester tester) async {
    // Provide sample uid and email for testing
    final String uid = 'test_uid';
    final String email = 'test@example.com';

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: AddProfile(uid, email), // Pass the uid and email
      ),
    );

    // Simulate filling in the form fields
    await tester.enterText(
        find.widgetWithText(TextField, 'Insert your name'), 'Mario');
    await tester.enterText(
        find.widgetWithText(TextField, 'Insert your surname'), 'R');
    await tester.enterText(
        find.widgetWithText(TextField, 'Update phone number'), '1234567890');
    await tester.enterText(
        find.widgetWithText(TextField, 'Insert your address'),
        'viale Roma 12, Milano');

    // Tap the Save button
    await tester.tap(find.text('SAVE'));
    await tester.pumpAndSettle();

    //TODO: UPDATE MISSING NAME WITH NEW MESSAGE
    expect(find.text('Missing surname'), findsOneWidget);
    expect(find.text('Error!'), findsOneWidget);
    expect(find.text('Please check the inserted values!'), findsOneWidget);
  });

  testWidgets('AddProfile: user provides number with wrong format',
      (WidgetTester tester) async {
    // Provide sample uid and email for testing
    final String uid = 'test_uid';
    final String email = 'test@example.com';

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: AddProfile(uid, email), // Pass the uid and email
      ),
    );

    // Simulate filling in the form fields
    await tester.enterText(
        find.widgetWithText(TextField, 'Insert your name'), 'Mario');
    await tester.enterText(
        find.widgetWithText(TextField, 'Insert your surname'), 'Rossi');
    await tester.enterText(
        find.widgetWithText(TextField, 'Update phone number'), '120');
    await tester.enterText(
        find.widgetWithText(TextField, 'Insert your address'),
        'viale Roma 12, Milano');

    // Tap the Save button
    await tester.tap(find.text('SAVE'));
    await tester.pumpAndSettle();

    //TODO: UPDATE MISSING NAME WITH NEW MESSAGE
    expect(find.text('Wrong number format'), findsOneWidget);
    expect(find.text('Error!'), findsOneWidget);
    expect(find.text('Please check the inserted values!'), findsOneWidget);
  });
}

// flutter test test/WidgetTests/userTests/add_profile_screen_test.dart