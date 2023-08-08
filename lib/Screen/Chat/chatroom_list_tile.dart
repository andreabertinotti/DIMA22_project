import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Services/database_service.dart';
import 'chat_screen.dart';
import 'lateral_chat_screen.dart';

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myEmail;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myEmail);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String email = "",
      profilePicUrl =
          "https://firebasestorage.googleapis.com/v0/b/testappproject-329013.appspot.com/o/images%2Faccountpic.png?alt=media&token=94d81c05-78f6-46ff-a000-491cffdd6107";

  getThisUserInfo() async {
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      email =
          widget.chatRoomId.replaceAll(widget.myEmail, "").replaceAll("_", "");
      QuerySnapshot querySnapshot =
          await DatabaseService().getUserDocumentByEmail(email);

      profilePicUrl = "${querySnapshot.docs[0]["pic_url"]}";
    } else {
      email = "test@email.com";
      profilePicUrl = "";
    }

    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MediaQuery.of(context).size.width < 500
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(email, widget.myEmail)))
            : showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LateralChatScreen(
                    email: email,
                    myEmail: widget.myEmail,
                  );
                });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                profilePicUrl,
                height: 40,
                width: 40,
              ),
            ),
            Flexible(child: SizedBox(width: 12)),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    email.substring(0, email.indexOf('@')),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text(widget.lastMessage)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
