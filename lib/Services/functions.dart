import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
//
//Future<String> retrieveLockerAddress(String locker) async {
//  if (locker == 'Select a locker') {
//    return '';
//  }
//  String lockerAddress = '';
//  if (locker == 'Leonardo') {
//    lockerAddress = 'P.zza Leonardo da Vinci 32, Milano';
//  } else if (locker == 'Garibaldi') {
//    lockerAddress = 'viale Luigi Sturzo 45, Milano';
//  } else if (locker == 'Duomo') {
//    lockerAddress = 'Piazza Duomo 21, Milano';
//  } else if (locker == 'Darsena') {
//    lockerAddress = 'v.le G. D\'Annunzio 30, Milano';
//  } else if (locker == 'Centrale') {
//    lockerAddress = 'Piazza Duca D\'Aosta 8, Milano';
//  } else if (locker == 'Bovisa') {
//    lockerAddress = 'via Lambruschini 9, Milano';
//  }
//  return lockerAddress;
//}

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
