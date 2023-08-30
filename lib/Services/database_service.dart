import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<Stream<QuerySnapshot>> getUserByEmail(String email) async {
    return FirebaseFirestore.instance
        .collection("User")
        .where("email", isGreaterThanOrEqualTo: email)
        .where("email", isLessThan: email + 'z')
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserDocumentByEmail(
      String email) async {
    return await FirebaseFirestore.instance
        .collection('User')
        .where('email', isEqualTo: email)
        .get();
  }
}

Stream<List<Map<String, dynamic>>> fetchReservations(String userUid) {
  final DateTime currentTime = DateTime.now();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userUid)
      .collection('reservations')
      .where('reservationEndDate',
          isGreaterThan: Timestamp.fromDate(currentTime))
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((reservationDoc) {
      Map<String, dynamic> reservationData =
          reservationDoc.data()! as Map<String, dynamic>;
      reservationData['id'] = reservationDoc.id;
      return reservationData;
    }).toList();
  });
}

Stream<List<Map<String, dynamic>>> fetchReservationsHistory(String userUid) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userUid)
      .collection('reservations')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((reservationDoc) {
      Map<String, dynamic> reservationData =
          reservationDoc.data()! as Map<String, dynamic>;
      reservationData['id'] = reservationDoc.id;
      return reservationData;
    }).toList();
  });
}

//Future<List<Map<String, dynamic>>> fetchReservationsHistory(
//    String userUid) async {
//  QuerySnapshot reservationSnapshot = await FirebaseFirestore.instance
//      .collection('users')
//      .doc(userUid)
//      .collection('reservations')
//      .get();
//
//  List<Map<String, dynamic>> reservations = [];
//
//  for (QueryDocumentSnapshot reservationDoc in reservationSnapshot.docs) {
//    if (reservationDoc.exists && reservationDoc.data() != null) {
//      Map<String, dynamic> reservationData =
//          reservationDoc.data()! as Map<String, dynamic>;
//      reservationData['id'] =
//          reservationDoc.id; // Add the document ID to the map
//      reservations.add(reservationData);
//    }
//  }
//  return reservations;
//}

Future<String> retrieveCellFare(
    String locker, String cell, int duration, bool bookingAuthorized) async {
  if (!bookingAuthorized) {
    return '';
  }
  DocumentSnapshot cellSnapshot = await FirebaseFirestore.instance
      .collection('lockers')
      .doc(locker)
      .collection('cells')
      .doc(cell)
      .get();

  double cellFare = cellSnapshot['cellFare'] as double;
  String fare = (cellFare * duration).toStringAsFixed(2);
  String renderedFare = '$fare€';
  return renderedFare;
}

Future<List<Map<String, dynamic>>> fetchLockers() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('lockers').get();

  List<Map<String, dynamic>> result = [];

  querySnapshot.docs.forEach((DocumentSnapshot doc) {
    result.add(doc.data() as Map<String, dynamic>);
  });

  return result;
}
