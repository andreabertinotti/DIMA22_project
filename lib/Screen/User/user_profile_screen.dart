// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro/Screen/User/edit_profile_screen.dart';
import 'package:pro/Screen/User/add_profile_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

//TODO: retrieve user data from db
class _ProfilePageState extends State<ProfilePage> {
// Method to get the current user UID
  String? getCurrentUserUid() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('userUID',
              isEqualTo: getCurrentUserUid()) // Filter by userUID field
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No data available.'),
          );
        }

        final docs = snapshot.data?.docs;
        if (docs == null || docs.isEmpty) {
          return Center(
            child: Text('No data available.'),
          );
        }
        // Extract user data from the document snapshot
        var userData = snapshot.data!.docs[0];

        return Scaffold(
          body: Column(
            children: [
              Flexible(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        // User image
                        minRadius: 40,
                        maxRadius: 60,
                        backgroundColor: Colors.orange,
                      ),
                      Text(
                        '${userData['name'] ?? ''} ${userData['surname'] ?? ''}',
                        style: TextStyle(fontSize: 25),
                      ), // User name&surname under image
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 35),
                        child: Text(
                          'Name: ${userData['name'] ?? ''}',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 35),
                        child: Text(
                          'Surname: ${userData['surname'] ?? ''}',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 35),
                        child: Text(
                          'Phone Number: ${userData['phone'] ?? ''}',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 35),
                        child: Text(
                          'Address: ${userData['address'] ?? ''}',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 35),
                        child: Text(
                          'Email: ${userData['email'] ?? ''}',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 35, bottom: 35),
                        child: Text(
                          'Other info: ...',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Floating button to open edit profile page
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfile()),
              );
            },
            backgroundColor: Color(0xFFFF9800),
            child: Icon(Icons.edit),
          ),
        );
      },
    );
  }
}
