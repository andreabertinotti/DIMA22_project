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
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('userUID', isEqualTo: _user?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data!.docs.isEmpty) {
            return AddProfile();
          }
          return ProfilePage(snapshot
              .data!.docs[0]); // Assuming you're using the first document
        },
      ),
    );
  }
}
