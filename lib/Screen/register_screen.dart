import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/auth_service.dart';

final formGlobalKey = GlobalKey<FormState>();

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
        body: Center(
      child: Form(
        key: formGlobalKey,
        child: (Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: Text("Insert email and password")),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 200,
                child: TextFormField(
                  //validator: (value) => EmailFieldValidator.validate(value!),
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 200,
                child: TextFormField(
                  //validator: (value) => PasswordFieldValidator.validate(value!),
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (formGlobalKey.currentState!.validate()) {
                    authService!
                        .createUserWithEmailAndPassword(
                            emailController.text, passwordController.text)
                        .then((usr) => {
                              FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(usr!.uid)
                                  .set({
                                "username": usr!.email!
                                    .substring(0, usr.email!.indexOf('@')),
                                "email": usr.email,
                                // TODO: IMPLEMENT PIC
                                //"pic_url":
                              })
                            });
                    Navigator.pop(context);
                  }
                },
                child: Text("Register")),
          ],
        )),
      ),
    ));
  }
}
