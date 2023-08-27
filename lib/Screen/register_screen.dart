import 'dart:io';
import 'package:pro/Screen/login_screen.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        toolbarHeight: 0,
      ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 80, bottom: 25),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(shape: BoxShape.circle, 
                  image:  DecorationImage(
                    image: AssetImage(
                        'assets/images/circleAppLogo.png'),
                        fit: BoxFit.cover)),
                ),
              ),
              Text(
                "Welcome to Milan Locker!", 
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 35),
                child: Text("Please register to start using the app", style: TextStyle(fontSize: 16),),
              ),
              Center(
                child: Form(
                  key: formGlobalKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width > 500 
                            ? MediaQuery.of(context).size.width * 0.4 
                            : MediaQuery.of(context).size.width * 0.75,
                          child: TextFormField(
                            validator: (value) => EmailFieldValidator.validate(value!),
                            controller: emailController,
                            cursorColor: Colors.orange,
                            decoration: const InputDecoration(
                             labelText: "Email", focusColor: Colors.orange, floatingLabelStyle: TextStyle(color: Colors.orange),
                              border: OutlineInputBorder(), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.orange))
                            ),
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
                            validator: (value) => PasswordFieldValidator.validate(value!),
                            obscureText: true,
                            cursorColor: Colors.orange,
                            controller: passwordController,
                            decoration: const InputDecoration(
                              labelText: "Password", focusColor: Colors.orange, floatingLabelStyle: TextStyle(color: Colors.orange),
                              border: OutlineInputBorder(), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.orange))
                            ),
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
                                        })
                                      });
                              Navigator.pop(context);
                            }
                            else{
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Registration Error"),
                                    content: Text(
                                        "Please check the inserted values for email and password"),
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
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side:BorderSide(color: Colors.orange)))),
                          child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 18),)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already a member?"),
                            TextButton(
                              onPressed: () {
                                  Navigator.pop(context);
                              }, 
                              child: const Text("Login", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),)
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              )
            ]
          ),
        ) 
      );
  }
}
