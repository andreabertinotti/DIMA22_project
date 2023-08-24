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
