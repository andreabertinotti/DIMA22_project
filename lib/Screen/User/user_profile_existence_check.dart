import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro/Screen/User/add_profile_screen.dart';
import 'package:pro/Screen/User/user_profile_screen.dart';

class ProfileCheckScreen extends StatefulWidget {
  const ProfileCheckScreen({Key? key}) : super(key: key);

  @override
  State<ProfileCheckScreen> createState() => _ProfileCheckScreenState();
}

class _ProfileCheckScreenState extends State<ProfileCheckScreen> {
  bool isLoading = true;
  bool profileExists = false;

  @override
  void initState() {
    super.initState();
    checkUserProfile();
  }

  Future<void> checkUserProfile() async {
    // Get the current user's UID, replace this with your authentication logic.
    final User? user = FirebaseAuth.instance.currentUser;
    // Check if the user is logged in.
    if (user != null) {
      final String uid = user.uid;
      // Get the UID of the logged-in user.

      try {
        // Retrieve the user document from Firestore based on the userUID field.
        final QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('userUID', isEqualTo: uid)
            .get();

        setState(() {
          // If any documents match the query, set profileExists to true.
          profileExists = userQuerySnapshot.docs.isNotEmpty;
          isLoading = false;
        });
      } catch (e) {
        // Handle any errors that might occur during the Firestore query.
        setState(() {
          isLoading = false;
        });
        print("Error checking user profile: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : profileExists
              ? ProfilePage()
              : AddProfile(),
    );
  }
}
