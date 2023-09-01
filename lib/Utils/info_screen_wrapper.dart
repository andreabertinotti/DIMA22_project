import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro/Screen/info_screen_tablet.dart';
import 'package:pro/Screen/login_screen.dart';
import '../Screen/info_screen_mobile.dart';

class MenuWrapper extends StatefulWidget {
  const MenuWrapper({Key? key}) : super(key: key);

  @override
  State<MenuWrapper> createState() => _MenuWrapperState();
}

class _MenuWrapperState extends State<MenuWrapper> {
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return _user == null
        ? LoginScreen()
        : Scaffold(
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('userUID', isEqualTo: _user?.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.data!.docs.isEmpty) {
                  return MediaQuery.of(context).size.width > 500 
                  ? MenuTablet(null,_user?.uid,)
                  : MenuMobile(null,_user?.uid,)
                  ;
                }

                return MediaQuery.of(context).size.width > 500
                ? MenuTablet(snapshot.data!.docs[0],_user!.uid,)
                : MenuMobile(snapshot.data!.docs[0],_user!.uid,);
              },
            ),
          );
  }
}
