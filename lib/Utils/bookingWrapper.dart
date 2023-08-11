import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/user_model.dart';
import '../Services/auth_service.dart';
import '../Screen/login_screen.dart';
import '../Screen/Reservations/reservation_add.dart';

//Wrapper used to open the EditBooking page since it needs the userId as a parameter

class BookingWrapper extends StatelessWidget {
  BookingWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null ? LoginScreen() : EditBooking(uid: snapshot.data!.uid);
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
