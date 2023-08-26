// ignore_for_file: prefer_const_constructors, prefer_final_fields, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:pro/Screen/my_home.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //more controllers to be added if more info is added on profile page

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<
      ScaffoldMessengerState>(); //key for scaffold manager (to display snackbar)
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false; //If application is still loading content
  bool _nameValid = true;
  bool _surnameValid = true; //checks for profile fields inserted
  bool _numberValid = true;
  bool _addressValid = true;
  bool _emailValid = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true; //page starts loading content
    });

    try {
      // Retrieve the user document from Firestore using the current user's uid
      final userUid = FirebaseAuth.instance.currentUser?.uid;
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userUID', isEqualTo: userUid)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        // Document with userUID exists, update the TextEditingController values
        final userDoc = userQuerySnapshot.docs.first;
        final userData = userDoc;

        nameController.text = userData['name'] ?? '';
        surnameController.text = userData['surname'] ?? '';
        phoneController.text = userData['phone'] ?? '';
        addressController.text = userData['address'] ?? '';
        //emailController.text = FirebaseAuth.instance.currentUser?.email ?? '';
      } else {
        nameController.text = 'Mario';
        surnameController.text = 'Rossi';
        phoneController.text = '1234567890';
        addressController.text = 'Kings street 104, London, UK';
        //emailController.text = 'email';
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }

    setState(() {
      isLoading = false; //Page ends loading content
    });
  }

  Column buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: "Update name",
            errorText: _nameValid ? null : "Missing name",
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
          decoration: InputDecoration(
            hintText: "Update surname",
            errorText: _surnameValid ? null : "Missing surname",
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
          decoration: InputDecoration(
            hintText: "Update phone number",
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
          decoration: InputDecoration(
            hintText: "Update address",
            errorText: _addressValid ? null : "Wrong address format",
          ),
        )
      ],
    );
  }

  void updateData(BuildContext context) async {
    // Save the data entered by the user in variables
    String name = nameController.text;
    String email = FirebaseAuth.instance.currentUser?.email ?? "";
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    String phoneNumber = phoneController.text;
    String surname = surnameController.text;
    String address = addressController.text;

    // Check if the user document already exists
    try {
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userUID', isEqualTo: uid)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        // Document with userUID exists, update the user data in the existing document
        final userDoc = userQuerySnapshot.docs.first;
        await userDoc.reference.update({
          'name': name,
          'surname': surname,
          'email': email,
          'phone': phoneNumber,
          'address': address,
        });
      } else {
        // Document with userUID doesn't exist, create a new document in the "users" collection
        await FirebaseFirestore.instance.collection('users').add({
          'name': name,
          'surname': surname,
          'email': email,
          'phone': phoneNumber,
          'address': address,
          'userUID': uid,
        });
      }

      // Show a success message to the user
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Data Updated'),
            content: Text('Your profile has been updated!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  //Navigator.pushReplacement(context,
                  //  MaterialPageRoute(builder: (context) => MyHome()));
                },
                child: Text('OK'),
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
            title: Text('Error'),
            content: Text('An error occurred while updating your data.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            title: const Text(
              'Update your profile',
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
                      padding: EdgeInsets.only(
                        top: 25,
                        bottom: 8,
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.orange,
                        child: Center(
                            child: Text(
                          (nameController.text.isEmpty)
                              ? surnameController.text.isEmpty
                                  ? "??"
                                  : "?${surnameController.text[0]}"
                              : surnameController.text.isEmpty
                                  ? "${nameController.text[0]}?"
                                  : "${nameController.text[0]}${surnameController.text[0]}", //Initials on user image
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    Padding(
                      padding: MediaQuery.of(context).size.width > 600
                          ? EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.2,
                              right: MediaQuery.of(context).size.width * 0.2,
                              top: 25,
                              bottom: 45)
                          : EdgeInsets.only(
                              left: 25, right: 25, top: 25, bottom: 35),
                      child: Column(
                        children: [
                          buildNameField(), //Insert all the fields through methods defined above
                          buildSurnameField(),
                          buildNumberField(),
                          //buildEmailField(),
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
                                nameController.text.isEmpty
                                    ? _nameValid = false
                                    : _nameValid = true;
                                surnameController.text.isEmpty
                                    ? _surnameValid = false
                                    : _surnameValid = true;
                                phoneController.text.length < 9 ||
                                        phoneController.text.length > 11
                                    ? _numberValid = false
                                    : _numberValid = true;
                                //check address correctness
                                addressController.text.contains(',')
                                    ? _addressValid = true
                                    : _addressValid = false;
                                //email validator package to be implemented
                              });

                              //If all fields are correct, update the values in the db
                              if (_nameValid &&
                                  _surnameValid &&
                                  _numberValid &&
                                  _addressValid &&
                                  _emailValid) {
                                updateData(context);
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
                              "Update data".toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          )),
                    )
                  ],
                ),
        ));
  }
}
