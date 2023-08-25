import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pro/Screen/Reservations/reservations_list.dart';

void main() {
  testWidgets('BookingsPage displays correctly', (WidgetTester tester) async {
    // Build the BookingsPage widget
    await tester.pumpWidget(
      MaterialApp(
        home: BookingsPage(uid: 'test_uid'),
      ),
    );

    // Expect the loading spinner to be shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Pump a loading state to the widget
    await tester.pumpAndSettle();

    // Verify that the app bar title is displayed
    expect(find.text('My Reservations'), findsOneWidget);

    // Verify that the 'History' and 'Add' icons are displayed
    expect(find.byIcon(Icons.history), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // TODO: Add more specific widget tests based on your application's behavior
  });
}
