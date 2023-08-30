import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pro/Screen/login_screen.dart';

void main() {
  testWidgets('One Register button must be present (go to register page)',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    final textFinder = find.textContaining("Register");

    expect(textFinder, findsOneWidget);
  });

  testWidgets('One Login button must be present', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    final textFinder = find.textContaining("Login");

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Email field must be present', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    final textFinder = find.textContaining("Email");

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Password field must be present', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    final textFinder = find.textContaining("Password");

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Title and text must be present', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    final textFinder = find.textContaining("Welcome to Milan Lockers!");
    expect(find.text('Keep your stuff safe!'), findsOneWidget);

    expect(textFinder, findsOneWidget);
  });
}

// flutter test test/WidgetTests/login_screen_test.dart