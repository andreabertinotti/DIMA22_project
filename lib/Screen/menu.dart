import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/auth_service.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 38,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.logout,
            semanticLabel: "sign out",
          ),
          onPressed: () {
            authService.signOut();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Handle "My reservations" button press
              // You can navigate to the respective page or perform any action here
            },
            child: Text('My reservations'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle "Manage account" button press
              // You can navigate to the respective page or perform any action here
            },
            child: Text('Manage account'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle "Help" button press
              // You can navigate to the respective page or perform any action here
            },
            child: Text('Help'),
          ),
          ElevatedButton(
            onPressed: () {
              authService.signOut(); // Handle "Logout" button press
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
