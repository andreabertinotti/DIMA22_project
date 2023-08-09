// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/auth_service.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      /*appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange[800],
        foregroundColor: Colors.white,
        title: Text('Milan Baggage keeper'),
        leading: IconButton(
          icon: Icon(
            Icons.logout,
            semanticLabel: "sign out",
          ),
          onPressed: () {
            authService.signOut();
          },
        ),
      ),*/
      appBar: AppBar(backgroundColor: Colors.orange[900], toolbarHeight: 0,),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 120,
            child: Stack(
              children: [
                Container(
                  color: Colors.orange[900],
                  width: double.infinity,
                  height: 120,
                ),
                const Positioned(
                  top: 20,
                  right: 15,
                  child: CircleAvatar(
                    // User image
                    radius: 40,
                    backgroundColor: Colors.orange,
                    child: Center(
                      child: Text(
                        "MR", //TODO: retrieve user initials from db
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40, 
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                  ),
                ),
                const Positioned(
                  left: 20,           //TODO: retrieve person name from db
                  top: 30,
                  child: Text('Welcome\nMario Rossi', style: TextStyle(color: Colors.white, fontSize: 25))
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rules of the lockers service',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris posuere cursus magna, at commodo elit volutpat a. Maecenas ante felis, tempus ut feugiat nec, vestibulum non elit. Ut euismod consequat nisl, sit amet aliquam magna consectetur eu. In aliquam venenatis mi, quis facilisis mauris tempus sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut aliquam sed augue eget mollis. Ut fringilla ligula non nunc luctus, sit amet rutrum sem tempus. Nullam sit amet mauris varius, suscipit ante vel, commodo neque. Integer sed justo a dolor scelerisque dignissim id et magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 40,),
                Text(
                  'In case of errors please write an email to:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'riccardo1.gianni@mail.polimi.it',
                  textAlign: TextAlign.justify,
                ),
                Text(
                  'andrea.bertinotti@mail.polimi.it',
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          authService.signOut(); // Handle "Logout" button press
        },
        backgroundColor: Colors.orange[900],
        child: Icon(Icons.logout, color: Colors.white,),
      ),
    );
  }
}
