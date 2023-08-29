import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pro/Screen/Reservations/reservation_tile_horizontal.dart';

void main() {
  testWidgets('ReservationTileHorizontal displays correctly',
      (WidgetTester tester) async {
    final DateTime mockDropOff = DateTime(2023, 8, 27, 10, 0);
    final DateTime mockPickUp = DateTime(2023, 8, 27, 15, 0);
    const String mockPrice = '5€';
    const String mockLocker = 'Leonardo';
    const String mockCell = 'cell 0 (small)';
    const int mockDuration = 5;
    const String mockReservationId = '123456';
    const String mockAddress = 'via Roma 1, Milano';

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReservationTileHorizontal(
            dropOff: mockDropOff,
            pickUp: mockPickUp,
            price: mockPrice,
            locker: mockLocker,
            cell: mockCell,
            duration: mockDuration,
            reservationId: mockReservationId,
            address: mockAddress,
            onDelete: () {}, // Provide an empty function for onDelete
          ),
        ),
      ),
    );

    // Verify that the widget displays the correct information
    expect(
        find.text(
            'Drop-off: ${DateFormat('dd/MM/yyyy, HH:mm').format(mockDropOff)}'),
        findsOneWidget);
    expect(
        find.text(
            'Pick-up: ${DateFormat('dd/MM/yyyy, HH:mm').format(mockPickUp)}'),
        findsOneWidget);
    expect(find.text('Price: $mockPrice'), findsOneWidget);
    expect(find.text('Duration: $mockDuration hours'), findsOneWidget);
    expect(find.text('Cell: $mockCell'), findsOneWidget);
    expect(find.text('Address: $mockAddress'), findsOneWidget);

    // Verify delete button is displayed correctly
    expect(find.text('Delete booking'), findsOneWidget);
  });
}


// flutter test test/WidgetTests/reservationsListTest/reservation_tile_horizontal_test.dart