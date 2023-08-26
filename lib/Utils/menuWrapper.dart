//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import '../Models/user_model.dart';
//import '../Services/auth_service.dart';
//import '../Screen/login_screen.dart';
//
//// wrapping a widget: if user is logged in, wrapped widget will be returned, else LoginScreen() will
//
//class Wrapper extends StatelessWidget {
//  Wrapper({Key? key, required Widget this.widget}) : super(key: key);
//
//  Widget widget;
//
//
//Future<DocumentSnapshot?> getUserDocument(String userUID) async {
//  try {
//    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
//        .collection('users')
//        .where('userUID', isEqualTo: userUID)
//        .limit(1)
//        .get();
//
//    if (userQuerySnapshot.docs.isNotEmpty) {
//      DocumentSnapshot userDocument = userQuerySnapshot.docs[0];
//      return userDocument;
//    } else {
//      return null; // No matching document found
//    }
//  } catch (e) {
//    print('Error fetching user document: $e');
//    return null;
//  }
//}
//
//  @override
//  Widget build(BuildContext context) {
//    final authService = Provider.of<AuthService>(context);
//    return StreamBuilder<User?>(
//      stream: authService.user,
//      builder: (_, AsyncSnapshot<User?> snapshot) {
//        if (snapshot.connectionState == ConnectionState.active) {
//          final User? user = snapshot.data;
//          if (user == null) {
//            return LoginScreen();
//          } else {
//            userDoc = await getUserDocument(snapshot.data!.uid);
//                return Menu()
//          }
//        } else {
//          return const Scaffold(
//            body: Center(
//              child: CircularProgressIndicator(),
//            ),
//          );
//        }
//      },
//    );
//  }
//}
//