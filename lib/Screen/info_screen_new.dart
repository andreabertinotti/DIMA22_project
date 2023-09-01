// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final problemGlobalKey = GlobalKey<FormState>();

class Menu extends StatefulWidget {
  const Menu(this.document, this.uid, {super.key});
  final dynamic document;
  final dynamic uid;

  @override
  _MenuState createState() => _MenuState();
}

class ProblemFieldValidator {
  static String? validate(String value) {
    return (value.isEmpty || value.length > 600)
        ? 'Password can\'t be empty or shorter than 6 characters'
        : null;
  }
}

class _MenuState extends State<Menu> {
  TextEditingController problemController = TextEditingController();

  Future<String> loadRulesText() async {
    return await rootBundle.loadString('assets/texts/service_rules.txt');
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var userData = widget.document;

    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          title: const Text(
            'Info & Terms and Conditions',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: MediaQuery.of(context).size.width < 500 
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 120,
                child: widget.document == null
                    ? Stack(
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
                      )
                    : Stack(
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)))
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
                      height: 390,
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
                            controller: problemController,
                            minLines: 1,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText: "Description",
                              //errorText: problemController.text.isNotEmpty ? null : "Problem description can't be empty",
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('reports')
                                    .add({
                                  'userUid': widget.uid,
                                  'locker': problemController.text,
                                  'timestamp': DateTime.now(),
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Report sent successfully!"),
                                  backgroundColor: Colors.green,
                                ));
                                Navigator.of(context).pop();
                                print(problemController.text);
                              },
                              child: Text(
                                'Submit',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.orange),
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
          )
          : Row(
            children: [
              Expanded(
                child: Container(
                  height: double.infinity,
                  margin: EdgeInsets.all(20),
                  child: SingleChildScrollView(
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
                          height: 390,
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
                  )
                  
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 15.0, // soften the shadow
                        spreadRadius: 5.0, //extend the shadow
                        offset: Offset(
                          5.0, // Move to right 5  horizontally
                          5.0, // Move to bottom 5 Vertically
                        ),
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 25),
                          width: double.infinity,
                          child: Text(
                            'Report a problem',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Did you find a problem in the app? Do you have something to report about the lockers? Please let us know what\'s wrong in the following form field and we\'ll try to solve is as soon as possible!',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        TextField(
                          controller: problemController,
                          minLines: 11,
                          maxLines: 11,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.5,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Problem description (max 600 characters)",
                            labelText: "Description",
                            alignLabelWithHint: true,
                            focusColor: Colors.orange,
                            floatingLabelStyle: TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange, width: 2))
                          ),
                          cursorColor: Colors.orange,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: ElevatedButton(
                            onPressed: () {
                              //print(problemController.text.length);
                              if(problemController.text.length > 600 || problemController.text.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Please check the problem description: it must not be empty or longer than 600 characters"), 
                                    backgroundColor: Colors.red,
                                  )
                                );
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Report sent successfully!"), 
                                    backgroundColor: Colors.green,
                                  )
                                );
                                FirebaseFirestore.instance
                                      .collection('reports')
                                      .add({
                                    'userUid': widget.uid,
                                    'locker': problemController.text,
                                    'timestamp': DateTime.now(),
                                  });
                                setState(() {
                                  problemController.text = "";
                                });
                              }

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
                            child: Text("submit".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                )),
                          )
                        ),
                      ],
                    ),
                  )                
                )
              )
            ],
          ),
      )
    );
  }
}
