import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro/Services/auth_service.dart';
import 'package:provider/provider.dart';

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

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formGlobalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Login Requested!"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    child: TextFormField(
                      validator: (value) =>
                          EmailFieldValidator.validate(value!),
                      controller: emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) =>
                          PasswordFieldValidator.validate(value!),
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: "Password"),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formGlobalKey.currentState!.validate()) {
                      try {
                        final result = await authService!
                            .signInWithEmailAndPassword(
                                emailController.text, passwordController.text);

                        if (result == null) {
                          // Show user-not-found error dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Authentication Error"),
                                content: Text(
                                    "The provided email and password do not match any existing account."),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("OK"),
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
                              title: Text("Authentication Error"),
                              content: Text(
                                  "The provided email and password do not match any existing account."),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: const Text("Login"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Don't have an account yet?"),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: const Text("Register")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
