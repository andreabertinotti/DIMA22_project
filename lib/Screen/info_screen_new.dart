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
  bool _problemValid = true;

  Future<String> loadRulesText() async {
    return await rootBundle.loadString('assets/texts/service_rules.txt');
  }

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
          ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /* Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.orange[900],
                  child: Center(
                    child: Text(
                      widget.document == null ? 'Your profile is not complete!' : 'Logged in as: ${userData['email'] ?? ''}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                      )
                    )
                  )
                ), */
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Terms of Use',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // Add some spacing between title and text
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.65,
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
                                style: TextStyle(fontSize: 16),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        problemController.clear();
                      });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Report a problem',
                                style: TextStyle(color: Colors.orange),
                              ),
                              contentPadding: EdgeInsets.only(left: 24, right: 24, bottom: 0, top: 20),
                              content: SizedBox(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: Text(
                                          'Did you find a problem in the app? Do you have something to report about the lockers? Please let us know what\'s wrong in the following form field and we\'ll try to solve is as soon as possible!',
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      TextField(
                                        controller: problemController,
                                        minLines: 5,
                                        maxLines: 5,
                                        textAlign: TextAlign.justify,
                                        decoration: InputDecoration(
                                          hintText: "Problem description (max 600 characters)",
                                          labelText: "Description",
                                          alignLabelWithHint: true,
                                          focusColor: Colors.orange,
                                          floatingLabelStyle: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.orange, width: 2))
                                        ),
                                        cursorColor: Colors.orange,
                                      ),
                                    ],
                                  ),
                                )
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      problemController.text.length > 600 || problemController.text.isEmpty 
                                      ? _problemValid = false
                                      : _problemValid = true;
                                    });

                                    if(_problemValid){
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
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Report sent successfully!"), 
                                          backgroundColor: Colors.green,
                                        )
                                      );
                                      Navigator.of(context).pop();
                                    }
                                    else{
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Report Error",
                                              style: TextStyle(color: Colors.orange),
                                            ),
                                            contentPadding: EdgeInsets.only(left: 24, right: 24, bottom: 0, top: 20),
                                            content: Text(
                                                "The problem description cannot be empty or longer than 600 characters"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(color: Colors.orange),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
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
                  ),
                ),
              ],
            )
          )
          : Row(
            children: [
              Expanded(
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.only(left: 30, top: 40, right: 40),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Terms of Use',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 25, bottom: 10),
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
                                  style: TextStyle(
                                    fontSize: 18
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
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
                            height: 1.2,
                          ),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(120,255,255,255),
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
