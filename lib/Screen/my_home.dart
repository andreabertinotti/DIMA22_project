import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro/Screen/Reservations/reservations_list.dart';
import 'package:pro/Screen/Reservations/reservations_screen.dart';
import 'package:pro/Screen/User/user_profile_existence_check.dart';
import 'package:pro/Screen/menu.dart';
import 'package:provider/provider.dart';
import '../Services/auth_service.dart';
import '../Theme/Theme.dart';
import '../Utils/wrapper.dart';
import '../firebase_options.dart';
import 'home_view.dart';
import '../Utils/bookingWrapper.dart';


class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _selectedIndex =
      0; // this will help keeping track of what item has been tapped
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static final List<Widget> _widgetOptions = <Widget>[
    //home builder is in form of future builder since we have to wait for the connection to firebase to happen
    FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        //case in which connection to firebase has an error
        if (snapshot.hasError) {
          print("error:  ${snapshot.error.toString()}");
          return const Text("Warning: An error occourred! (e0)");
        }

        //case in which there is no data
        if (!snapshot.hasData) return const Text("No data is present!");

        //////////////////////////////////////////////////
        //case of succesful connection  --> use home_view
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return HomeView();
        }

        //if no previous case is suitable, then show the loading indicator
        return const Text("Loading please...");
      },
    ),

    //Wrapper manages the login screen, if usr is not logged, login-screen is returned, else the specific widget
    //Wrapper(widget: SocialScreen()),
    //Wrapper(widget: ChatHome()),
    Wrapper(widget: BookingsPage()),
    //BookingWrapper(),
    //Wrapper(widget: ReservationsScreen()),
    Wrapper(widget: ProfileCheckScreen()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner:
            false, //Turns on a little "DEBUG" banner in debug mode to indicate that the app is in debug mode. This is on by default (in debug mode), to turn it off, set the constructor argument to false. In release mode this has no effect.
        theme: appTheme,
        title: 'Flutter layout demo',
        home: Scaffold(
          //drawer is the menu that can be hidden on left side
          drawer: Drawer(
            child: Wrapper(widget: Menu()),
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),

          // TO BE CHANGED: in the bottom bar we have 3 buttons: home, social, chat, host
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                backgroundColor: Colors.orange,
                label: 'Home',
              ),
              //BottomNavigationBarItem(
              //  icon: Icon(Icons.group),
              //  backgroundColor: Colors.black,
              //  label: 'Social',
              //),
              //BottomNavigationBarItem(
              //  icon: Icon(Icons.send),
              //  backgroundColor: Colors.black,
              //  label: 'Chat',
              //),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                backgroundColor: Colors.orange,
                label: 'My Reservations',
              ),
              /* BottomNavigationBarItem(
                icon: Icon(Icons.add),
                backgroundColor: Colors.orange,
                label: 'Add Reservations',
              ), */
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                backgroundColor: Colors.orange,
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            backgroundColor: Colors.orange,
            selectedItemColor: Colors.black,  //TODO: change colors
            unselectedItemColor: Colors.white,
            unselectedLabelStyle: TextStyle(color: Colors.white),
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
