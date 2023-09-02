import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pro/Screen/User/user_profile_screen.dart';

void main() {
  testWidgets('ProfilePage displays user data correctly',
      (WidgetTester tester) async {
    final fakeFirestore = FakeFirebaseFirestore();
    await fakeFirestore.collection('users').doc('user_id').set({
      'name': 'Mario',
      'surname': 'Rossi',
      'email': 'mario@example.com',
      'address': 'via Roma 1, Milano',
      'phone': '555-1234',
    });

    await tester.pumpWidget(
      MaterialApp(
        home: ProfilePage({
          'name': 'Mario',
          'surname': 'Rossi',
          'email': 'mario@example.com',
          'address': 'via Roma 1, Milano',
          'phone': '555-1234'
        }),
      ),
    );

    // Ensure that the user's name and surname are displayed
    expect(find.text('Mario Rossi'), findsNWidgets(2));

    // Ensure that the user's email is displayed
    expect(find.text('mario@example.com'), findsOneWidget);

    // Ensure that the user's address is displayed
    expect(find.text('via Roma 1, Milano'), findsOneWidget);

    // Ensure that the user's phone is displayed
    expect(find.text('555-1234'), findsOneWidget);
    expect(find.text('EDIT PROFILE'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}


// flutter test test/WidgetTests/userTests/user_profile_screen_test.dart