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
}


// flutter test test/WidgetTests/register_screen_test.dart