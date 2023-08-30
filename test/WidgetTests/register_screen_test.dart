import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pro/Screen/register_screen.dart';

void main() {
  testWidgets('One Register button must be present',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: Register()));
    final textFinder = find.textContaining("Register");

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Email field must be present', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: Register()));
    final textFinder = find.textContaining("Email");

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Password field must be present', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: Register()));
    final textFinder = find.textContaining("Password");

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Title and text must be present', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: Register()));
    final textFinder = find.textContaining("Welcome to Milan Lockers!");
    expect(textFinder, findsOneWidget);
    expect(find.text('Please register to start using the app'), findsOneWidget);
  });

  testWidgets('Login button must be present (go to login page)',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: Register()));

    expect(find.text('Login'), findsOneWidget);
  });
}


// flutter test test/WidgetTests/register_screen_test.dart