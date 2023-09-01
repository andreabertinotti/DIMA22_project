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
      'address': 'via Roma 1, Milano',
    };

    // Add the mock userData document to the fake Firestore
    firestore.collection('users').add(mockUserData);

    // Build the EditProfile widget with the mock userData
    await tester.pumpWidget(
      MaterialApp(
        home: EditProfile(mockUserData),
      ),
    );

    expect(find.text('Update your profile'), findsOneWidget);

// Verify that the all the field names are correctly populated
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Surname'), findsOneWidget);
    expect(find.text('Phone number'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);

    // Verify that the all the fields are correctly populated
    expect(find.text('Mario'), findsOneWidget);
    expect(find.text('Rossi'), findsOneWidget);
    expect(find.text('1234567890'), findsOneWidget);
    expect(find.text('via Roma 1, Milano'), findsOneWidget);
// Verify that the button correctly is correctly displayed
    expect(find.text('UPDATE DATA'), findsOneWidget);
  });

  testWidgets('Edit profile hints are displayed correctly',
      (WidgetTester tester) async {
    // Create a fake instance of Cloud Firestore
    final firestore = FakeFirebaseFirestore();

    // Define the mock userData document
    final mockUserData = {
      'name': 'Mario',
      'surname': 'Rossi',
      'phone': '1234567890',
      'address': 'via Roma 1, Milano',
    };

    // Add the mock userData document to the fake Firestore
    firestore.collection('users').add(mockUserData);

    // Build the EditProfile widget with the mock userData
    await tester.pumpWidget(
      MaterialApp(
        home: EditProfile(mockUserData),
      ),
    );

    // user ereases text in the pre-filled text forms
    await tester.enterText(find.text('Mario'), '');
    await tester.enterText(find.text('Rossi'), '');
    await tester.enterText(find.text('1234567890'), '');
    await tester.enterText(find.text('via Roma 1, Milano'), '');

    // Verify that the all the fields are correctly populated
    expect(find.text('Update name'), findsOneWidget);
    expect(find.text('Update surname'), findsOneWidget);
    expect(find.text('Update address'), findsOneWidget);
    expect(find.text('Update phone number'), findsOneWidget);
  });

  testWidgets('User provides too short phone number',
      (WidgetTester tester) async {
    // Create a fake instance of Cloud Firestore
    final firestore = FakeFirebaseFirestore();

    // Define the mock userData document
    final mockUserData = {
      'name': 'Mario',
      'surname': 'Rossi',
      'phone': '1234567890',
      'address': 'via Roma 1, Milano',
    };

    // Add the mock userData document to the fake Firestore
    firestore.collection('users').add(mockUserData);

    // Build the EditProfile widget with the mock userData
    await tester.pumpWidget(
      MaterialApp(
        home: EditProfile(mockUserData),
      ),
    );

    await tester.enterText(find.text('1234567890'), '123467');
    await tester.tap(find.text('UPDATE DATA'));
    await tester.pumpAndSettle();

    expect(find.text('Wrong number format'), findsOneWidget);
    expect(find.text('Error!'), findsOneWidget);
    expect(find.text('Please check the inserted values!'), findsOneWidget);
  });

  testWidgets('User provides too short name', (WidgetTester tester) async {
    // Create a fake instance of Cloud Firestore
    final firestore = FakeFirebaseFirestore();

    // Define the mock userData document
    final mockUserData = {
      'name': 'Mario',
      'surname': 'Rossi',
      'phone': '1234567890',
      'address': 'via Roma 1, Milano',
    };

    // Add the mock userData document to the fake Firestore
    firestore.collection('users').add(mockUserData);

    // Build the EditProfile widget with the mock userData
    await tester.pumpWidget(
      MaterialApp(
        home: EditProfile(mockUserData),
      ),
    );

    await tester.enterText(find.text('Mario'), 'M');
    await tester.tap(find.text('UPDATE DATA'));
    await tester.pumpAndSettle();

    expect(find.text('Name is too short'), findsOneWidget);
    expect(find.text('Error!'), findsOneWidget);
    expect(find.text('Please check the inserted values!'), findsOneWidget);
  });

  testWidgets('User provides too short surname', (WidgetTester tester) async {
    // Create a fake instance of Cloud Firestore
    final firestore = FakeFirebaseFirestore();

    // Define the mock userData document
    final mockUserData = {
      'name': 'Mario',
      'surname': 'Rossi',
      'phone': '1234567890',
      'address': 'via Roma 1, Milano',
    };

    // Add the mock userData document to the fake Firestore
    firestore.collection('users').add(mockUserData);

    // Build the EditProfile widget with the mock userData
    await tester.pumpWidget(
      MaterialApp(
        home: EditProfile(mockUserData),
      ),
    );

    await tester.enterText(find.text('Rossi'), 'R');
    await tester.tap(find.text('UPDATE DATA'));
    await tester.pumpAndSettle();

    expect(find.text('Surname is too short'), findsOneWidget);
    expect(find.text('Error!'), findsOneWidget);
    expect(find.text('Please check the inserted values!'), findsOneWidget);
  });
}


// flutter test test/WidgetTests/userTests/edit_profile_screen_test.dart
