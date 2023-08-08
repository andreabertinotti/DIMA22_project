import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro/Screen/Host/change_propic.dart';
import 'package:pro/Services/database_service.dart';

class ProfilePic extends StatefulWidget {
  ProfilePic({Key? key, required this.email, required this.uid})
      : super(key: key);

  String email, uid;
  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: DatabaseService().getUserDocumentByEmail(widget.email),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final doc = snapshot.data!.docs[0];
          final picUrl = doc.get('pic_url');

          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  picUrl,
                  height: 100,
                  width: 100,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: GestureDetector(
                  child: Text(
                    'change profile pic',
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeProPic(uid: widget.uid),
                      ),
                    );
                    setState(() {});
                  },
                ),
              ),
            ],
          );
        } else {
          return Text('No data');
        }
      },
    );
  }
}
