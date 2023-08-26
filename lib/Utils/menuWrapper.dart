import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/user_model.dart';
import '../Screen/menu.dart';
import '../Services/auth_service.dart';
import '../Screen/login_screen.dart';

// wrapping a widget: if user is logged in, wrapped widget will be returned, else LoginScreen() will

class MenuWrapper extends StatelessWidget {
  MenuWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          } else {
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.done) {
                  if (userSnapshot.hasData) {
                    final userData = userSnapshot.data!.data();
                    // Pass userData to Menu widget
                    return Menu(userData);
                  } else {
                    return const Center(
                      child: Text('Error fetching user data'),
                    );
                  }
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
