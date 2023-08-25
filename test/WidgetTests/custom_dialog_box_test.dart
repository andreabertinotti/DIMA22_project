import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pro/Utils/bookingLockerWrapper_horizontalView.dart';
import 'package:pro/Utils/custom_dialog_box.dart';
import 'package:pro/Utils/image_view.dart';

void main() {
  testWidgets('CustomDialogBox widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: CustomDialogBox(
          document: {
            'lockerName': 'Leonardo',
            'lockerAddress': 'viale Roma 22 Milano',
            'smallCellFare': 2.0,
            'largeCellFare': 3.0,
          },
          map: {}, // You can add the necessary map data here
        ),
      ),
    );

    // Verify if the texts are properly displayed
    expect(find.text('Leonardo locker'), findsOneWidget);
    expect(find.text('Address: viale Roma 22 Milano'), findsOneWidget);
    expect(find.text('Small cell fare: 2.0€/hour'), findsOneWidget);
    expect(find.text('Large cell fare: 3.0€/hour'), findsOneWidget);

    // Verify if the 'Book this locker' button is present
    expect(find.text('BOOK THIS LOCKER'), findsOneWidget);

    // Tap the 'Book this locker' button and verify the navigation
    //await tester.tap(find.text('BOOK THIS LOCKER'));
    //await tester.pumpAndSettle();

    // Verify if BookingLockerHorizontalWrapper page is displayed
    //expect(find.byType(BookingLockerHorizontalWrapper), findsOneWidget);
  });
}


//flutter test test/WidgetTests/custom_dialog_box_test.dart