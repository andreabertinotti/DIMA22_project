// ignore_for_file: prefer_const_constructors, prefer_final_fields, library_private_types_in_public_api
//import 'dart:js_util';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:pro/Services/auth_service.dart';
import 'package:provider/provider.dart';

class AddProfile extends StatefulWidget {
  const AddProfile(this.uid, this.email, {super.key});
  final dynamic uid;
  final dynamic email;

  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  //more controllers to be added if more info is added on profile page

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<
      ScaffoldMessengerState>(); //key for scaffold manager (to display snackbar)
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool isLoading = false; //If application is still loading content
  bool _nameValid = true;
  bool _surnameValid = true; //checks for profile fields inserted
  bool _numberValid = true;
  bool _addressValid = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true; //page starts loading content
    });
    nameController.text = '';
    surnameController.text = '';
    phoneController.text = '';
    addressController.text = '';
    setState(() {
      isLoading = false; //Page ends loading content
    });
  }

  Column buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: Text(
              "Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: nameController,
          cursorColor: Colors.orange,
          decoration: InputDecoration(
            hintText: "Insert your name",
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 2.0)),
            errorText: _nameValid ? null : "Name must be longer than 2 characters",
          ),
        )
      ],
    );
  }

  Column buildSurnameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Surname",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: surnameController,
          cursorColor: Colors.orange,
          decoration: InputDecoration(
            hintText: "Insert your surname",
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 2.0)),
            errorText: _surnameValid ? null : "Surname must be longer than 2 characters",
          ),
        )
      ],
    );
  }

  Column buildNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Phone number",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: phoneController,
          cursorColor: Colors.orange,
          decoration: InputDecoration(
            hintText: "Update phone number",
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 2.0)),
            errorText: _numberValid ? null : "Wrong number format",
          ),
        )
      ],
    );
  }

  Column buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Address",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: addressController,
          cursorColor: Colors.orange,
          decoration: InputDecoration(
            hintText: "Insert your address",
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 2.0)),
            errorText: _addressValid ? null : "Address must be between 3 and 70 characters",
          ),
        )
      ],
    );
  }

  void updateData(BuildContext context) async {
    // Save the data entered by the user in variables
    String name = nameController.text;
    //String email = FirebaseAuth.instance.currentUser?.email ?? "";
    //String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    String email = widget.email;
    String uid = widget.uid;
    String phoneNumber = phoneController.text;
    String surname = surnameController.text;
    String address = addressController.text;

    // Create a new document in the "users" collection with the user's data
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'surname': surname,
        'email': email,
        'phone': phoneNumber,
        'address': address,
        'userUID': uid,
      });
      // Show a success message to the user
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Data Updated', style: TextStyle(color: Colors.orange),),
            content: Text('Your profile has been succesfully completed!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK', style: TextStyle(color: Colors.orange),),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Show an error message if something goes wrong
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error', style: TextStyle(color: Colors.orange),),
            content: Text('An error occurred while updating your data.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK', style: TextStyle(color: Colors.orange),),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //final authService = Provider.of<AuthService>(context);
    AuthService? authService = null;
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      authService = Provider.of<AuthService>(context);
    }
    return ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: const Text(
              'Complete your profile',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: isLoading
              ? const CircularProgressIndicator() //If the page is still loading content display a circular progress indicator
              : ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 25, bottom: 8),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/circleAppLogo.png'),
                            fit: BoxFit.contain
                          )
                        ),
                      ),
                    ),
                    Padding(
                      padding: MediaQuery.of(context).size.width > 600
                          ? EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.2,
                              right: MediaQuery.of(context).size.width * 0.2,
                              top: 0,
                              bottom: 20)
                          : EdgeInsets.only(
                              left: 25, right: 25, top: 20, bottom: 20),
                      child: Column(
                        children: [
                          buildNameField(), //Insert all the fields through methods defined above
                          buildSurnameField(),
                          buildNumberField(),
                          buildAddressField(),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                          height: 40,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                //Check all fields' correctness before saving
                                nameController.text.length < 2
                                    ? _nameValid = false
                                    : _nameValid = true;
                                surnameController.text.length < 2
                                    ? _surnameValid = false
                                    : _surnameValid = true;
                                //Check phone number correctness through regular expression
                                RegExp(r'^(\+\d{1,2}\s?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$').hasMatch(phoneController.text)
                                    ? _numberValid = true
                                    : _numberValid = false;
                                addressController.text.length < 3 || addressController.text.length > 69
                                  ? _addressValid = false
                                  : _addressValid = true;                                    
                              });

                              //If all fields are correct, update the values in the db
                              if (_nameValid &&
                                  _surnameValid &&
                                  _numberValid &&
                                  _addressValid) {
                                updateData(context);
                              } 
                              else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Error!", style: TextStyle(color: Colors.orange),),
                                      content: Text(
                                          "Please check the inserted values!"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("OK", style: TextStyle(color: Colors.orange),),
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
                                        borderRadius: BorderRadius.circular(18),
                                        side:
                                            BorderSide(color: Colors.orange)))),
                            child: Text(
                              "Save".toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          )),
                    )
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    //if (!Platform.environment.containsKey('FLUTTER_TEST')) {
                    authService?.signOut(); // Handle "Logout" button press
                    //}
                  },
                  backgroundColor: Colors.orange[900],
                  child: Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                  ),
                ),
        ));
  }
}
