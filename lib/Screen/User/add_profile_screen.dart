// ignore_for_file: prefer_const_constructors, prefer_final_fields, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class AddProfile extends StatefulWidget {
  const AddProfile({super.key});

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
    nameController.text = 'Mario'; //TODO: retrieve data from db
    surnameController.text = 'Rossi';
    phoneController.text = '1234567890';
    addressController.text = 'Kings street 104, London, UK';
    emailController.text = 'email';
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
            hintText: "Insert your name",
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
            hintText: "Insert your surname",
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
            hintText: "Insert your phone number",
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
            hintText: "Insert your address",
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

    // Create a new document in the "users" collection with the user's data
    try {
      await FirebaseFirestore.instance.collection('users').add({
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
            title: Text('Data Updated'),
            content: Text('Your profile has been succesfully completed!'),
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
                      padding: EdgeInsets.only(
                        top: 25,
                        bottom: 8,
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.orange,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
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

                                SnackBar editSnackbar = SnackBar(
                                  content:
                                      Text("Profile completed successfully!"),
                                  backgroundColor: Colors.green,
                                );
                                //Display a snackbar when content is saved
                                _scaffoldMessengerKey.currentState
                                    ?.showSnackBar(editSnackbar);
                              } else {
                                SnackBar editSnackbar = SnackBar(
                                  content:
                                      Text("Please, check the inserted data"),
                                  backgroundColor: Colors.red,
                                );
                                //If there are wrong fields, display a snackbar with an error message
                                _scaffoldMessengerKey.currentState
                                    ?.showSnackBar(editSnackbar);
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
        ));
  }
}
