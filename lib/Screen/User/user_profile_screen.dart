// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pro/Screen/User/edit_profile_screen%20old.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(this.userData, {super.key});
  final dynamic userData;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
// Method to get the current user UID
  // String? getCurrentUserUid() {
  //   final user = FirebaseAuth.instance.currentUser;
  //   return user?.uid;
  // }

  @override
  Widget build(BuildContext context) {
    return widget.userData == null
        ? Center(child: Text('No data available.'))
        : Scaffold(
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
                                "${widget.userData['name'][0] ?? ''}${widget.userData['surname'][0] ?? ''}", //Initials on user image
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold),
                              )),
                            )),
                      ),
                      Positioned(
                        top: 50,
                        child: Text(
                          '${widget.userData['name'] ?? ''} ${widget.userData['surname'] ?? ''}',
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: MediaQuery.of(context).size.width > 600
                      ? EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.2,
                          right: MediaQuery.of(context).size.width * 0.2,
                          top: 10)
                      : EdgeInsets.only(left: 25, right: 25, top: 10),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.black.withOpacity(0.2)))),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: Colors.orange,
                        size: 45,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${widget.userData['name'] ?? ''} ${widget.userData['surname'] ?? ''}',
                        style: TextStyle(
                            fontSize: widget.userData['name'].length +
                                        widget.userData['surname'].length >
                                    30
                                ? 15
                                : 18),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: MediaQuery.of(context).size.width > 600
                      ? EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.2,
                          right: MediaQuery.of(context).size.width * 0.2,
                          top: 25)
                      : EdgeInsets.only(left: 25, right: 25, top: 25),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.black.withOpacity(0.2)))),
                  child: Row(
                    children: [
                      Icon(
                        Icons.mail_outline,
                        color: Colors.orange,
                        size: 45,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${widget.userData['email'] ?? ''}',
                        style: TextStyle(
                            fontSize:
                                widget.userData['email'].length > 30 ? 15 : 18),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: MediaQuery.of(context).size.width > 600
                      ? EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.2,
                          right: MediaQuery.of(context).size.width * 0.2,
                          top: 25)
                      : EdgeInsets.only(left: 25, right: 25, top: 25),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.black.withOpacity(0.2)))),
                  child: Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        color: Colors.orange,
                        size: 45,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${widget.userData['address'] ?? ''}',
                        style: TextStyle(
                            fontSize: widget.userData['address'].length > 30
                                ? 15
                                : 18),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: MediaQuery.of(context).size.width > 600
                      ? EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.2,
                          right: MediaQuery.of(context).size.width * 0.2,
                          top: 25)
                      : EdgeInsets.only(left: 25, right: 25, top: 25),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.black.withOpacity(0.2)))),
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        color: Colors.orange,
                        size: 45,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${widget.userData['phone'] ?? ''}',
                        style: TextStyle(fontSize: 18),
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
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          );
  }
}
