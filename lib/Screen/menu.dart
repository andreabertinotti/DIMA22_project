// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../Services/auth_service.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // Method to get the current user UID
  String? getCurrentUserUid() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  TextEditingController descriptionController = TextEditingController();

  Future<String> loadRulesText() async {
    return await rootBundle.loadString('assets/texts/service_rules.txt');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

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

        //// HANDLE CASE IN WHICH USER STILL HASN'T COMPLETED PROFILE DATA
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.docs.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange[900],
              toolbarHeight: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.orange[900],
                          width: double.infinity,
                          height: 120,
                        ),
                        Positioned(
                          top: 20,
                          right: 15,
                          child: CircleAvatar(
                            // User image
                            radius: 40,
                            backgroundColor: Colors.orange,
                            child: Center(
                                child: Text(
                              "!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                        Positioned(
                            left: 10,
                            top: 45,
                            child: Text('Your profile is not complete!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold))),
                        Positioned(
                            left: 10,
                            top: 65,
                            child: Text('Complete it in the profile page',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13))),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Terms of Use',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          height: 10), // Add some spacing between title and text
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: FutureBuilder<String>(
                            future: loadRulesText(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text("Error loading rules");
                              }
                              return Text(
                                snapshot.data ?? "No rules available",
                                textAlign: TextAlign.justify,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Report a problem',
                                style: TextStyle(color: Colors.orange),
                              ),
                              content: TextField(
                                controller: descriptionController,
                                minLines: 1,
                                maxLines: 6,
                                decoration: InputDecoration(
                                  hintText: "Description",
                                  //errorText: descriptionController.text.isNotEmpty ? null : "Problem description can't be empty",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('reports')
                                        .add({
                                      'userUid': getCurrentUserUid(),
                                      'locker': descriptionController.text,
                                      'timestamp': DateTime.now(),
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Report sent successfully!"), backgroundColor: Colors.green,));
                                    Navigator.of(context).pop();
                                    print(descriptionController.text);
                                  },
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.orange),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.orange),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: BorderSide(color: Colors.orange)))),
                    child: Text("Report a problem".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                authService.signOut(); // Handle "Logout" button press
              },
              backgroundColor: Colors.orange[900],
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          );
        }

        //// HANDLE CASE IN WHICH USER STILL HASN'T COMPLETED PROFILE DATA (second case: no document in db for logged user)
        final docs = snapshot.data?.docs;
        if (docs == null || docs.isEmpty) {
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange[900],
              toolbarHeight: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.orange[900],
                          width: double.infinity,
                          height: 120,
                        ),
                        Positioned(
                          top: 20,
                          right: 15,
                          child: CircleAvatar(
                            // User image
                            radius: 40,
                            backgroundColor: Colors.orange,
                            child: Center(
                                child: Text(
                              "!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                        Positioned(
                            left: 10,
                            top: 45,
                            child: Text('Your profile is not complete!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold))),
                        Positioned(
                            left: 10,
                            top: 65,
                            child: Text('Complete it in the profile page',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13))),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Terms of Use',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          height: 10), // Add some spacing between title and text
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: FutureBuilder<String>(
                            future: loadRulesText(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text("Error loading rules");
                              }
                              return Text(
                                snapshot.data ?? "No rules available",
                                textAlign: TextAlign.justify,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Report a problem',
                                style: TextStyle(color: Colors.orange),
                              ),
                              content: TextField(
                                controller: descriptionController,
                                minLines: 1,
                                maxLines: 6,
                                decoration: InputDecoration(
                                  hintText: "Description",
                                  //errorText: descriptionController.text.isNotEmpty ? null : "Problem description can't be empty",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('reports')
                                        .add({
                                      'userUid': getCurrentUserUid(),
                                      'locker': descriptionController.text,
                                      'timestamp': DateTime.now(),
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Report sent successfully!"), backgroundColor: Colors.green,));
                                    Navigator.of(context).pop();
                                    print(descriptionController.text);
                                  },
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.orange),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.orange),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: BorderSide(color: Colors.orange)))),
                    child: Text("Report a problem".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                authService.signOut(); // Handle "Logout" button press
              },
              backgroundColor: Colors.orange[900],
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          );
        }

        /////////////////////////////////////////////////////////
        /// HANDLE CASE IN WHICH USER HAS ALREADY COMPLETED HIS PROFILE
        // Extract user data from the document snapshot
        var userData = snapshot.data!.docs[0];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange[900],
            toolbarHeight: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 120,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.orange[900],
                      width: double.infinity,
                      height: 120,
                    ),
                    Positioned(
                      top: 20,
                      right: 15,
                      child: CircleAvatar(
                        // User image
                        radius: 40,
                        backgroundColor: Colors.orange,
                        child: Center(
                            child: Text(
                          "${userData['name'][0] ?? ''}${userData['surname'][0] ?? ''}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    Positioned(
                        left: 20,
                        top: 30,
                        child: Text(
                            'Welcome\n${userData['name'] ?? ''} ${userData['surname'] ?? ''}',
                            style:
                                TextStyle(color: Colors.white, fontSize: 25)))
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms of Use',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height: 10), // Add some spacing between title and text
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: FutureBuilder<String>(
                          future: loadRulesText(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text("Error loading rules");
                            }
                            return Text(
                              snapshot.data ?? "No rules available",
                              textAlign: TextAlign.justify,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Report a problem',
                            style: TextStyle(color: Colors.orange),
                          ),
                          content: TextField(
                            controller: descriptionController,
                            minLines: 1,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText: "Description",
                              //errorText: descriptionController.text.isNotEmpty ? null : "Problem description can't be empty",
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('reports')
                                    .add({
                                  'userUid': getCurrentUserUid(),
                                  'locker': descriptionController.text,
                                  'timestamp': DateTime.now(),
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Report sent successfully!"), backgroundColor: Colors.green,));
                                Navigator.of(context).pop();
                                print(descriptionController.text);
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.orange),
                              ),
                            ),
                          ],
                        );
                      });
                },
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orange),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(color: Colors.orange)))),
                child: Text("Report a problem".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    )),
              )
            ],
          ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              authService.signOut(); // Handle "Logout" button press
            },
            backgroundColor: Colors.orange[900],
            child: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
