import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro/Screen/User/add_profile_screen.dart';
import 'package:pro/Screen/login_screen.dart';

import '../Screen/User/edit_profile_screen.dart';

class EditProfileWrapper extends StatefulWidget {
  const EditProfileWrapper({Key? key}) : super(key: key);

  @override
  State<EditProfileWrapper> createState() => _EditProfileWrapperState();
}

class _EditProfileWrapperState extends State<EditProfileWrapper> {
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
                  return AddProfile(_user?.uid, _user?.email);
                }
                return EditProfile(snapshot
                    .data!.docs[0]); // Assuming you're using the first document
              },
            ),
          );
  }
}
