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

  testWidgets(
      'User tries to Login without filling the email and password fields',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNWidgets(1));
    expect(find.text('Login Error'), findsOneWidget);
    expect(find.text('Please check the inserted values for email and password'),
        findsOneWidget);

    // close alert dialog
    await tester.tap(find.text('OK'));

    expect(find.text('Invalid Email'), findsOneWidget);
    expect(find.text('Password can\'t be empty or shorter than 6 characters'),
        findsOneWidget);
  });

  testWidgets('User tries to login with wronlgly fromatted email',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    final emailField = find.widgetWithText(TextFormField, 'Email');
    final passwordField = find.widgetWithText(TextFormField, 'Password');

    // email with wrong formatting
    await tester.enterText(emailField, 'wrong.email');
    // in this case password is fine
    await tester.enterText(passwordField, 'verystroNGpassWord229!');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNWidgets(1));
    expect(find.text('Login Error'), findsOneWidget);
    expect(find.text('Please check the inserted values for email and password'),
        findsOneWidget);

    // close alert dialog
    await tester.tap(find.text('OK'));

    expect(find.text('Invalid Email'), findsOneWidget);
  });

  testWidgets('User tries to Login with short password',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    final emailField = find.widgetWithText(TextFormField, 'Email');
    final passwordField = find.widgetWithText(TextFormField, 'Password');

    // email is fine
    await tester.enterText(emailField, 'fakeemail@test.it');
    // in this case password is fine
    await tester.enterText(passwordField, 'short');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNWidgets(1));
    expect(find.text('Login Error'), findsOneWidget);
    expect(find.text('Please check the inserted values for email and password'),
        findsOneWidget);

    // close alert dialog
    await tester.tap(find.text('OK'));

    expect(find.text('Password can\'t be empty or shorter than 6 characters'),
        findsOneWidget);
  });

  testWidgets('User tries to Login with well formed but wrong credentials',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    final emailField = find.widgetWithText(TextFormField, 'Email');
    final passwordField = find.widgetWithText(TextFormField, 'Password');

    // email is fine
    await tester.enterText(emailField, 'fakeemail@test.it');
    // in this case password is fine
    await tester.enterText(passwordField, 'test_good_password');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNWidgets(1));
    expect(find.text('Authentication Error'), findsOneWidget);
    expect(
        find.text(
            'The provided email and password do not match any existing account.'),
        findsOneWidget);

    // close alert dialog
    await tester.tap(find.text('OK'));
  });
}

// flutter test test/WidgetTests/login_screen_test.dart