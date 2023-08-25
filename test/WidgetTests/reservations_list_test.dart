import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart'; // You might need this for mocking dependencies
import 'package:pro/Models/user_model.dart';
import 'package:pro/Screen/Reservations/reservations_list.dart';
import 'package:pro/Services/auth_service.dart';

// Mock AuthService for testing
class MockAuthService extends Mock implements AuthService {}

void main() {
  testWidgets('BookingsPage displays correctly', (WidgetTester tester) async {
    // Create a mock user for testing
    final mockUser = User('mockUserId', 'mockEmail');

    // Build the BookingsPage widget
    await tester.pumpWidget(
      MaterialApp(
        home: BookingsPage(),
      ),
    );

    // Expect the loading spinner to be shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Pump a loading state to the widget
    await tester.pumpAndSettle();

    // Verify that the app bar title is displayed
    expect(find.text('My Reservations'), findsOneWidget);

    // Verify that the 'History' and 'Add' icons are displayed
    expect(find.byIcon(Icons.history), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Mock AuthService and user data for the StreamBuilder
    final authService = MockAuthService();
    when(authService.user).thenAnswer((_) => Stream.value(mockUser));

    // Rebuild the widget with the mock user
    await tester.pumpWidget(
      MaterialApp(
        home: StreamBuilder<User?>(
          stream: Stream.value(mockUser),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return BookingsPage();
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );

    // Expect the loading spinner to be shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Pump a loading state to the widget
    await tester.pumpAndSettle();

    // Verify that the CustomListItems are displayed
    expect(find.byType(CustomListItem), findsWidgets);

    // TODO: Add more specific widget tests based on your application's behavior
  });
}
