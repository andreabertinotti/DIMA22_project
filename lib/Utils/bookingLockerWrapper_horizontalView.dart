import 'package:flutter/material.dart';
import 'package:pro/Screen/Reservations/reservation_add_locker_tablet.dart';
import 'package:provider/provider.dart';
import '../Models/user_model.dart';
import '../Services/auth_service.dart';
import '../Screen/login_screen.dart';

//Wrapper used to open the EditBooking page since it needs the userId as a parameter

class BookingLockerHorizontalWrapper extends StatelessWidget {
  final dynamic document;
  BookingLockerHorizontalWrapper(this.document, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    print('wrapper called');
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null
              ? LoginScreen()
              : AddLockerBookingTablet(document, uid: snapshot.data!.uid);
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
