import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/user_model.dart';
import '../Services/auth_service.dart';
import '../Screen/login_screen.dart';

// wrapping a widget: if user is logged in, wrapped widget will be returned, else LoginScreen() will

class Wrapper extends StatelessWidget {
  Wrapper({Key? key, required Widget this.widget}) : super(key: key);

  Widget widget;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null ? LoginScreen() : widget;
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
