// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Services/functions.dart';

final problemGlobalKey = GlobalKey<FormState>();

class InfoScreenVertical extends StatefulWidget {
  const InfoScreenVertical(this.uid, {super.key});
  final dynamic uid;

  @override
  _InfoScreenVerticalState createState() => _InfoScreenVerticalState();
}

class _InfoScreenVerticalState extends State<InfoScreenVertical> {
  TextEditingController problemController = TextEditingController();
  bool _problemValid = true;
    final GlobalKey<ScaffoldMessengerState> _reportScaffoldKey = GlobalKey<ScaffoldMessengerState>();

  // Future<String> loadRulesText() async {
  //   return await rootBundle.loadString('assets/texts/service_rules.txt');
  // }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _reportScaffoldKey,
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
            body: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                      ),
                      Container(
                        key: Key('text_key'),
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
                              contentPadding: EdgeInsets.only(
                                  left: 24, right: 24, bottom: 0, top: 20),
                              content: SizedBox(
                                  child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: Text(
                                        'Did you find a problem in the app? Do you have something to report about the lockers? Please let us know!',
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    TextField(
                                      controller: problemController,
                                      minLines: 5,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                          hintText:
                                              "Problem description (max 600 characters)",
                                          labelText: "Description",
                                          alignLabelWithHint: true,
                                          focusColor: Colors.orange,
                                          floatingLabelStyle: TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold),
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.orange,
                                                  width: 2))),
                                      cursorColor: Colors.orange,
                                    ),
                                  ],
                                ),
                              )),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      problemController.text.length > 600 ||
                                              problemController.text.isEmpty
                                          ? _problemValid = false
                                          : _problemValid = true;
                                    });

                                    if (_problemValid) {
                                      FirebaseFirestore.instance
                                          .collection('reports')
                                          .add({
                                        'userUid': widget.uid,
                                        'report': problemController.text,
                                        'timestamp': DateTime.now(),
                                      });
                                      setState(() {
                                        problemController.text = "";
                                      });
                                      _reportScaffoldKey.currentState?.showSnackBar(SnackBar(
                                        content:
                                            Text("Report sent successfully!"),
                                        backgroundColor: Colors.green,
                                      ));
                                      Navigator.of(context).pop();
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Report Error",
                                              style: TextStyle(
                                                  color: Colors.orange),
                                            ),
                                            contentPadding: EdgeInsets.only(
                                                left: 24,
                                                right: 24,
                                                bottom: 0,
                                                top: 20),
                                            content: Text(
                                                "The problem description cannot be empty or longer than 600 characters"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      color: Colors.orange),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
            ))));
  }
}
