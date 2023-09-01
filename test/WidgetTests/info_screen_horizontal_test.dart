import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pro/Screen/info_screen_horizontal.dart';

void main() {
  testWidgets('Info screen is correctly rendered', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: InfoScreenHorizontal('testUID'),
      ),
    );

    // Verify if the texts are properly displayed
    expect(find.text('Info & Terms and Conditions'), findsOneWidget);
    expect(find.text('Terms of Use'), findsOneWidget);
    expect(find.text('Report a problem'), findsOneWidget);
    expect(
        find.text(
            'Did you find a problem in the app? Do you have something to report about the lockers? Please let us know in this box and we\'ll take it on!'),
        findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('SUBMIT'), findsOneWidget);
  });

  // testWidgets('User inserts a report that is longer than 600 characters',
  //     (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: InfoScreenHorizontal('testUID'),
  //     ),
  //   );
//
  //   await tester.enterText(find.widgetWithText(TextField, 'Description'),
  //       'aaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCaaaaaaaaaabbbbbbbbbbccccccccccAAAAAAAAAABBBBBBBBBBCCCCCCCCCCdddddddddd');
//
  //   // Find the scrollable widget
  //   final scrollableFinder = find.byKey(Key('report_scroll'));
//
  //   // Scroll to the bottom by dragging from the top to the bottom
  //   await tester.drag(scrollableFinder, const Offset(0.0, -200.0));
  //   await tester.tap(find.text('SUBMIT'));
  //   await tester.pump();
  //   expect(
  //       find.text(
  //           'Please check the problem description: it must not be empty or longer than 600 characters'),
  //       findsOneWidget);
  // });
//
  testWidgets('User inserts a report and submits', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: InfoScreenHorizontal('testUID'),
      ),
    );

    await tester.enterText(
        find.widgetWithText(TextField, 'Description'), 'Report example');
  });
}


// flutter test test/WidgetTests/info_screen_horizontal_test.dart