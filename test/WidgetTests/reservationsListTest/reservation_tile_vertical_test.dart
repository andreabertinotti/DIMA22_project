import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pro/Screen/Reservations/reservation_tile_vertical.dart';

void main() {
  testWidgets('ReservationTileVertical displays reservation details',
      (WidgetTester tester) async {
    // Mock data for the reservation
    final DateTime mockDropOff = DateTime(2023, 8, 30, 10, 0);
    final DateTime mockPickUp = DateTime(2023, 8, 30, 16, 0);
    final String mockPrice = '2€';
    final String mockLocker = 'Leonardo';
    final String mockCell = 'cell 0 (large)';
    final int mockDuration = 6;
    final String mockReservationId = '12345';

    // Build the widget with mock data
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReservationTileVertical(
            dropOff: mockDropOff,
            pickUp: mockPickUp,
            price: mockPrice,
            locker: mockLocker,
            cell: mockCell,
            duration: mockDuration,
            reservationId: mockReservationId,
            onDelete: () {}, // Mock delete callback
          ),
        ),
      ),
    );

    // Find widgets containing mock data
    expect(
        find.text(
            "Drop-off: ${DateFormat('dd/MM/yyyy, HH:mm').format(mockDropOff)}"),
        findsOneWidget);
    expect(
        find.text(
            "Pick-up: ${DateFormat('dd/MM/yyyy, HH:mm').format(mockPickUp)}"),
        findsOneWidget);
    expect(find.text("Duration: $mockDuration hours"), findsOneWidget);
    expect(find.text("Cell: $mockCell"), findsOneWidget);
    expect(find.text("Price: $mockPrice"), findsOneWidget);

    // Verify delete button is displayed correctly
    expect(find.text('Delete booking'), findsOneWidget);
  });
}


// flutter test test/WidgetTests/reservationsListTest/reservation_tile_vertical_test.dart