import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro/Screen/info_screen_horizontal.dart';
import 'package:pro/Screen/login_screen.dart';
import '../Screen/info_screen_vertical.dart';

class MenuWrapper extends StatefulWidget {
  const MenuWrapper({Key? key}) : super(key: key);

  @override
  State<MenuWrapper> createState() => _MenuWrapperState();
}

class _MenuWrapperState extends State<MenuWrapper> {
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return _user == null
        ? LoginScreen()
        : MediaQuery.of(context).size.width > 500
            ? InfoScreenHorizontal(
                _user!.uid,
              )
            : InfoScreenVertical(
                _user!.uid,
              );
  }
}
