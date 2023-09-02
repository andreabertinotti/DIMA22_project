// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Services/functions.dart';

class InfoScreenHorizontal extends StatefulWidget {
  const InfoScreenHorizontal(this.uid, {super.key});
  final dynamic uid;

  @override
  _InfoScreenHorizontalState createState() => _InfoScreenHorizontalState();
}

class _InfoScreenHorizontalState extends State<InfoScreenHorizontal> {
  TextEditingController problemController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Future<String> loadRulesText() async {
  //   return await rootBundle.loadString('assets/texts/service_rules.txt');
  // }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _scaffoldMessengerKey,
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
          body: Row(
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
                            key: Key('text_key'),
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
                                    style: TextStyle(fontSize: 18),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Expanded(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 40),
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
                        key: Key('scrollview1'),
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
                                'Did you find a problem in the app? Do you have something to report about the lockers? Please let us know in this box and we\'ll take it on!',
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
                                  fillColor: Color.fromARGB(120, 255, 255, 255),
                                  hintText:
                                      "Problem description (max 600 characters)",
                                  labelText: "Description",
                                  alignLabelWithHint: true,
                                  focusColor: Colors.orange,
                                  floatingLabelStyle: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.orange, width: 2))),
                              cursorColor: Colors.orange,
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 25),
                                child: ElevatedButton(
                                  onPressed: () {
                                    //print(problemController.text.length);
                                    if (problemController.text.length > 600 ||
                                        problemController.text.isEmpty) {
                                      _scaffoldMessengerKey.currentState
                                          ?.showSnackBar(SnackBar(
                                        content: Text(
                                            "Please check the problem description: it must not be empty or longer than 600 characters"),
                                        backgroundColor: Colors.red,
                                      ));
                                    } else {
                                      _scaffoldMessengerKey.currentState
                                          ?.showSnackBar(SnackBar(
                                        content:
                                            Text("Report sent successfully!"),
                                        backgroundColor: Colors.green,
                                      ));
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
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.orange),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              side: BorderSide(
                                                  color: Colors.orange)))),
                                  child: Text("submit".toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      )),
                                )),
                          ],
                        ),
                      )))
            ],
          ),
        ));
  }
}
