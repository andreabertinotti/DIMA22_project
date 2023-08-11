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
          appBar: AppBar(
            backgroundColor: Colors.orange,
            toolbarHeight: 0,
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 240,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      color: Colors.orange,
                      width: double.infinity,
                      height: 180,
                    ),
                    Positioned(
                      top: 120,
                      child: CircleAvatar(
                        // User image
                        radius: 60,
                        backgroundColor: Colors.orange,
                        child: CircleAvatar(
                          radius: 58,
                          backgroundColor: Colors.white,
                          child: Center(
                          child: Text(
                            "${userData['name'][0] ?? ''}${userData['surname'][0] ?? ''}", //Initials on user image
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 60, 
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ),
                      )                        
                      ),
                    ),
                    Positioned(
                      top: 50,
                      child: Text(
                        '${userData['name'] ?? ''} ${userData['surname'] ?? ''}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 25, right: 25, top: 25),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.2)))),
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.orange, size: 45,),
                    SizedBox(width: 20,),
                    Text(
                      '${userData['name'] ?? ''} ${userData['surname'] ?? ''}',
                      style: TextStyle(
                        fontSize: userData['name'].length + userData['surname'].length > 30 ? 15 : 18
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.2)))),
                child: Row(
                  children: [
                    Icon(Icons.mail_outline, color: Colors.orange, size: 45,),
                    SizedBox(width: 20,),
                    Text(
                      '${userData['email'] ?? ''}',
                      style: TextStyle(
                        fontSize: userData['email'].length > 30 ? 15 : 18
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.2)))),
                child: Row(
                  children: [
                    Icon(Icons.place_outlined, color: Colors.orange, size: 45,),
                    SizedBox(width: 20,),
                    Text(
                      '${userData['address'] ?? ''}',
                      style: TextStyle(
                        fontSize: userData['address'].length > 30 ? 15 : 18
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.2)))),
                child: Row(
                  children: [
                    Icon(Icons.phone_outlined, color: Colors.orange, size: 45,),
                    SizedBox(width: 20,),
                    Text(
                      '${userData['phone'] ?? ''}',
                      style: TextStyle(
                        fontSize: 18
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 40),
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
            child: Icon(Icons.edit, color: Colors.white,),
          ),
        );
      },
    );
  }
}
