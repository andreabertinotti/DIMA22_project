import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pro/Screen/info_screen.dart';

void main() {
  testWidgets('Menu widget displays user data', (WidgetTester tester) async {
    final fakeFirestore = FakeFirebaseFirestore();
    final userData = {'name': 'Mario', 'surname': 'Rossi'}; // Mock user data

    await fakeFirestore.collection('users').doc('user_id').set(userData);

    await tester.pumpWidget(
      MaterialApp(
        home:
            Menu(userData, 'mock_uid'), // Simulate passing user ID as parameter
      ),
    );

    // Wait for widgets to settle
    await tester.pumpAndSettle();

    // Verify that user's name and surname are displayed
    expect(find.text('Welcome\nMario Rossi'), findsOneWidget);
    expect(find.text('MR'), findsOneWidget);
    expect(find.text('Terms of Use'), findsOneWidget);
  });

// CASE IN WHICH THE USER HASN'T A COMPLETE PROFILE
  testWidgets('Menu widget handles case of a user with profile not completed',
      (WidgetTester tester) async {
    //final fakeFirestore = FakeFirebaseFirestore();
// Mock user data

    //await fakeFirestore.collection('users').doc('user_id').set(userData);

    await tester.pumpWidget(
      MaterialApp(
        home: Menu(null, 'mock_uid'), // Simulate passing user ID as parameter
      ),
    );

    // Wait for widgets to settle
    //await tester.pumpAndSettle();

    // Verify that user's name and surname are displayed
    expect(find.text('Your profile is not complete!'), findsOneWidget);
    expect(find.text('Complete it in the profile page'), findsOneWidget);
    expect(find.text('!'), findsOneWidget);
    expect(find.text('Terms of Use'), findsOneWidget);
  });
}



// flutter test test/WidgetTests/info_screen_test.dart