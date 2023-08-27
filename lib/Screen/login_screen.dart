import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro/Services/auth_service.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'register_screen.dart';

final formGlobalKey = GlobalKey<FormState>();

class EmailFieldValidator {
  static String? validate(String value) {
    return (value.isEmpty ||
            !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                .hasMatch(value))
        ? 'Invalid Email'
        : null;
  }
}

class PasswordFieldValidator {
  static String? validate(String value) {
    return (value.isEmpty || value.length < 6)
        ? 'Password can\'t be empty or shorter than 6 characters'
        : null;
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    //AuthService? authService = null;
    //if (!Platform.environment.containsKey('FLUTTER_TEST')) {
    //  authService = Provider.of<AuthService>(context);
    //}

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.only(top: 80, bottom: 25),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage('assets/images/circleAppLogo.png'),
                    fit: BoxFit.cover)),
          ),
        ),
        Text(
          "Welcome to Milan Lockers!",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 35),
          child: Text(
            "Keep your stuff safe!",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Center(
          child: Form(
            key: formGlobalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width > 500
                        ? MediaQuery.of(context).size.width * 0.4
                        : MediaQuery.of(context).size.width * 0.75,
                    child: TextFormField(
                      cursorColor: Colors.orange,
                      validator: (value) =>
                          EmailFieldValidator.validate(value!),
                      controller: emailController,
                      decoration: const InputDecoration(
                          labelText: "Email",
                          focusColor: Colors.orange,
                          floatingLabelStyle: TextStyle(color: Colors.orange),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width > 500
                        ? MediaQuery.of(context).size.width * 0.4
                        : MediaQuery.of(context).size.width * 0.75,
                    child: TextFormField(
                      obscureText: true,
                      cursorColor: Colors.orange,
                      validator: (value) =>
                          PasswordFieldValidator.validate(value!),
                      controller: passwordController,
                      decoration: const InputDecoration(
                          labelText: "Password",
                          focusColor: Colors.orange,
                          floatingLabelStyle: TextStyle(color: Colors.orange),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange))),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  width: MediaQuery.of(context).size.width > 500
                      ? MediaQuery.of(context).size.width * 0.2
                      : MediaQuery.of(context).size.width * 0.45,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formGlobalKey.currentState!.validate()) {
                        try {
                          final result = await authService!
                              .signInWithEmailAndPassword(emailController.text,
                                  passwordController.text);

                          if (result == null) {
                            // Show user-not-found error dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Authentication Error",
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                  content: Text(
                                      "The provided email and password do not match any existing account."),
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
                        } catch (e) {
                          // Handle other exceptions here
                          //print("Error during authentication $e");
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Authentication Error",
                                  style: TextStyle(color: Colors.orange),
                                ),
                                content: Text(
                                    "The provided email and password do not match any existing account."),
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
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Login Error",
                                style: TextStyle(color: Colors.orange),
                              ),
                              content: Text(
                                  "Please check the inserted values for email and password"),
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
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account yet?"),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()));
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600),
                            )),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ])),
    );
  }
}
