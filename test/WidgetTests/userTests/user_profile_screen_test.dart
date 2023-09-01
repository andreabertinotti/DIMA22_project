import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pro/Screen/User/user_profile_screen.dart';

void main() {
  testWidgets('ProfilePage displays user data correctly',
      (WidgetTester tester) async {
    final fakeFirestore = FakeFirebaseFirestore();
    await fakeFirestore.collection('users').doc('user_id').set({
      'name': 'John',
      'surname': 'Doe',
      'email': 'john@example.com',
      'address': '123 Main St',
      'phone': '555-1234',
    });

    await tester.pumpWidget(
      MaterialApp(
        home: ProfilePage({
          'name': 'John',
          'surname': 'Doe',
          'email': 'john@example.com',
          'address': '123 Main St',
          'phone': '555-1234'
        }),
      ),
    );

    // Ensure that the user's name and surname are displayed
    expect(find.text('John Doe'), findsNWidgets(2));

    // Ensure that the user's email is displayed
    expect(find.text('john@example.com'), findsOneWidget);

    // Ensure that the user's address is displayed
    expect(find.text('123 Main St'), findsOneWidget);

    // Ensure that the user's phone is displayed
    expect(find.text('555-1234'), findsOneWidget);

    // Remember to add more tests based on your app's behavior and UI structure
  });
}


// flutter test test/WidgetTests/userTests/user_profile_screen_test.dart