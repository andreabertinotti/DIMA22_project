import 'package:flutter_test/flutter_test.dart';
import 'package:pro/Services/functions.dart';

void main() {
  group('generateReservedSlots', () {
    test('generates correct reserved slots', () {
      DateTime dropoffDate =
          DateTime(2023, 9, 1, 10, 0); // Sample dropoff date and time
      int dropoffHour = 10; // Sample dropoff hour
      int duration = 4; // Sample duration

      List<String> result =
          generateReservedSlots(dropoffDate, dropoffHour, duration);

      List<String> expectedSlots = [
        '2023090110',
        '2023090111',
        '2023090112',
        '2023090113',
      ]; // Expected reserved slots based on the input

      expect(result, equals(expectedSlots));
    });

    test('handles different date, dropoff hour, and duration', () {
      DateTime dropoffDate =
          DateTime(2023, 10, 24, 15, 0); // Sample dropoff date and time
      int dropoffHour = 15; // Sample dropoff hour
      int duration = 3; // Sample duration

      List<String> result =
          generateReservedSlots(dropoffDate, dropoffHour, duration);

      List<String> expectedSlots = [
        '2023102415',
        '2023102416',
        '2023102417',
      ]; // Expected reserved slots based on the input

      expect(result, equals(expectedSlots));
    });

    // Add more test cases as needed...
  });
}

// flutter test test/UnitTests/functions_test.dart