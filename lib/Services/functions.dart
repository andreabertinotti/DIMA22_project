import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

List<String> generateReservedSlots(
    DateTime dropoffDate, int dropoffHour, int duration) {
  // print(dropoffHour);
  List<String> reservedSlots = [];

  for (int i = 0; i < duration; i++) {
    DateTime slotDateTime = dropoffDate.add(Duration(hours: i));
    String slot = DateFormat('yyyyMMddHH').format(slotDateTime);
    reservedSlots.add(slot);
    //print(slot);
  }

  return reservedSlots;
}

Future<String> loadRulesText() async {
  return await rootBundle.loadString('assets/texts/service_rules.txt');
}
