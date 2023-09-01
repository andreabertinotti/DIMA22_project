import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pro/Screen/info_screen_vertical.dart';

void main() {
  testWidgets('Info screen is correctly rendered', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: InfoScreenVertical('testUID'),
      ),
    );

    // Verify if the texts are properly displayed
    expect(find.text('Info & Terms and Conditions'), findsOneWidget);
    expect(find.text('Terms of Use'), findsOneWidget);
    expect(find.text('REPORT A PROBLEM'), findsOneWidget);
  });

  testWidgets('Error report window is correctly displayed',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: InfoScreenVertical('testUID'),
      ),
    );

    await tester.tap(find.text('REPORT A PROBLEM'));
    await tester.pump();

    expect(find.text('Report a problem'), findsOneWidget);
    expect(
        find.text(
            'Did you find a problem in the app? Do you have something to report about the lockers? Please let us know!'),
        findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('User inserts a report that is longer than 600 characters',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: InfoScreenVertical('testUID'),
      ),
    );

    await tester.tap(find.text('REPORT A PROBLEM'));
    await tester.pump();

    await tester.enterText(find.widgetWithText(TextField, 'Description'),
        'aaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCdddddddddd');

    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.text('Report Error'), findsOneWidget);
    expect(
        find.text(
            'The problem description cannot be empty or longer than 600 characters'),
        findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pump();
  });

  testWidgets('User inserts a report and submits', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: InfoScreenVertical('testUID'),
      ),
    );

    await tester.tap(find.text('REPORT A PROBLEM'));
    await tester.pump();

    await tester.enterText(
        find.widgetWithText(TextField, 'Description'), 'Report example');
  });
}


// flutter test test/WidgetTests/info_screen_vertical_test.dart