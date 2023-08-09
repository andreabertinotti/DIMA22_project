import 'package:flutter/material.dart';
import 'package:pro/Models/user_model.dart';
import 'package:pro/Screen/Reservations/reservations_screen_horizontal.dart';
import 'package:pro/Screen/Reservations/reservations_screen_vertical.dart';
import 'package:pro/Services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:pro/Screen/menu.dart';
import 'package:pro/Utils/wrapper.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              title: const Text(
                'Milan Baggage keeper',     //Change app name (?)
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            drawer: Drawer(
              child: Wrapper(widget: Menu()),
            ),
            body: Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                  child: MediaQuery.of(context).size.width < 500
                      ? ReservationsScreenVertical(
                          snapshot: snapshot,
                        )
                      : ReservationsScreenHorizontal(
                          snapshot: snapshot,
                        )),
            ),
          );
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
