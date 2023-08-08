import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro/Screen/Chat/chat_screen.dart';
import 'package:pro/Services/database_service.dart';
import 'package:pro/Utils/get_chatroom_id_function.dart';

import '../../Models/user_model.dart';

class PostDetailsView extends StatelessWidget {
  Map<String, dynamic> data;
  User? user;
  final String docId;

  PostDetailsView(
      {Key? key, required this.data, required this.docId, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text(data['title'],
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 32.0,
              )),
        ),
      ),
      Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.fromLTRB(15, 0, 0, 30),
          child: Text(
            data['userMail'],
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
          )),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: Text(
            data['content'],
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ButtonTheme(
                buttonColor: Colors.deepOrangeAccent,
                child: ElevatedButton(
                  onPressed: () {
                    var chatRoomId = getChatRoomIdByUsernames(
                        user!.email!, data['userMail']);
                    Map<String, dynamic> chatRoomInfoMap = {
                      "emails": [user!.email!, data['userMail']],
                      "lastMessage": " ",
                    };
                    if (user!.email! != data['userMail']) {
                      DatabaseService()
                          .createChatRoom(chatRoomId, chatRoomInfoMap);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(data['userMail'], user!.email!)));
                    } else {
                      print("you can't chat with yourself!");
                    }
                  },
                  child: Icon(Icons.message),
                ),
              ),
            ],
          ))
    ]);
  }
}
