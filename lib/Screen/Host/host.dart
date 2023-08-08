import 'package:flutter/material.dart';
import 'package:pro/Models/user_model.dart';
import 'package:pro/Screen/Host/Host_Home/host_home_horizontal.dart';
import 'package:pro/Screen/Host/Host_Home/host_home_vertical.dart';
import 'package:pro/Services/auth_service.dart';
import 'package:provider/provider.dart';

class HostScreen extends StatefulWidget {
  const HostScreen({Key? key}) : super(key: key);

  @override
  _HostScreenState createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return Scaffold(
            body: Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                  child: MediaQuery.of(context).size.width < 500
                      ? HostHomeVertical(
                          snapshot: snapshot,
                        )
                      : HostHomeHorizontal(
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
