import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pro/Screen/User/edit_profile_screen.dart';

void main() {
  testWidgets('EditProfile widget test', (WidgetTester tester) async {
    // Create a fake instance of Cloud Firestore
    final firestore = FakeFirebaseFirestore();

    // Define the mock userData document
    final mockUserData = {
      'name': 'Mario',
      'surname': 'Rossi',
      'phone': '1234567890',
      'address': '123 Main St',
    };

    // Add the mock userData document to the fake Firestore
    firestore.collection('users').add(mockUserData);

    // Build the EditProfile widget with the mock userData
    await tester.pumpWidget(
      MaterialApp(
        home: EditProfile(mockUserData),
      ),
    );

// Verify that the all the field names are correctly populated
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Surname'), findsOneWidget);
    expect(find.text('Phone number'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);

    // Verify that the all the fields are correctly populated
    expect(find.text('Mario'), findsOneWidget);
    expect(find.text('Rossi'), findsOneWidget);
    expect(find.text('1234567890'), findsOneWidget);
    expect(find.text('123 Main St'), findsOneWidget);
// Verify that the button correctly is correctly displayed
    expect(find.text('UPDATE DATA'), findsOneWidget);
  });
}


// flutter test test/WidgetTests/userTests/edit_profile_screen_test.dart
