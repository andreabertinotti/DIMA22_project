import 'package:flutter/material.dart';
import 'package:pro/Models/user_model.dart';
import 'package:pro/Screen/Host/host_add.dart';
import 'package:pro/Screen/Host/host_map.dart';
import 'package:pro/Screen/Host/profile_pic.dart';

class HostHomeHorizontal extends StatelessWidget {
  AsyncSnapshot<User?> snapshot;

  HostHomeHorizontal({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            ProfilePic(email: snapshot.data!.email!, uid: snapshot.data!.uid),
            Text(
              "User email: " + snapshot.data!.email!,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                minWidth: 300,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HostMap(uid: snapshot.data!.uid)));
                  },
                  child: const Text(
                    "check my flats",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                minWidth: 300,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HostAdd(
                                  uid: snapshot.data!.uid,
                                  hostMail: snapshot.data!.email!,
                                )));
                  },
                  child: const Text(
                    "add new flat",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
