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
