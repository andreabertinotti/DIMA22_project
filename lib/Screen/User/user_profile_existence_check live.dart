import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro/Screen/User/add_profile_screen.dart';
import 'package:pro/Screen/User/user_profile_screen%20live.dart';

class ProfileCheckScreen extends StatefulWidget {
  const ProfileCheckScreen({Key? key}) : super(key: key);

  @override
  State<ProfileCheckScreen> createState() => _ProfileCheckScreenState();
}

class _ProfileCheckScreenState extends State<ProfileCheckScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  dynamic userEmail;
  dynamic userUid;

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      userEmail = user?.email;
      userUid = user?.uid;
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('userUID', isEqualTo: user?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data!.docs.isEmpty) {
            return AddProfile(userUid, userEmail);
          }
          return ProfilePage(snapshot
              .data!.docs[0]); // Assuming you're using the first document
        },
      ),
    );
  }
}
