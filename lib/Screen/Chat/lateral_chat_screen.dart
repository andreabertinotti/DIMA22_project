import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro/Utils/constants.dart';
import 'package:pro/Utils/get_chatroom_id_function.dart';
import 'package:random_string/random_string.dart';
import '../../Services/database_service.dart';

class LateralChatScreen extends StatefulWidget {
  final String email;
  final String myEmail;

  const LateralChatScreen({
    Key? key,
    required this.email,
    required this.myEmail,
  }) : super(key: key);

  @override
  _LateralChatScreenState createState() => _LateralChatScreenState();
}

class _LateralChatScreenState extends State<LateralChatScreen> {
  String chatRoomId = "";
  String messageId = "";
  Stream? messageStream;
  String? myName, myUserName;
  TextEditingController messageTextEditingController = TextEditingController();

  addMessage() {
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": widget.myEmail,
        "ts": lastMessageTs,
        //"imgUrl": myProfilePic
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseService()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": widget.myEmail
        };

        DatabaseService().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        // remove the text in the message input field
        messageTextEditingController.text = "";
        // make message id blank to get regenerated on next message send
        messageId = "";
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  bottomRight:
                      sendByMe ? const Radius.circular(0) : Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft:
                      sendByMe ? const Radius.circular(24) : Radius.circular(0),
                ),
                color: sendByMe ? Colors.blue : Colors.grey,
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: const EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTile(
                      ds["message"], widget.myEmail == ds["sendBy"]);
                })
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await DatabaseService().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    chatRoomId = getChatRoomIdByUsernames(widget.email, widget.myEmail);
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Dialog(
        insetPadding: const EdgeInsets.fromLTRB(300, 0, 0, 0),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        child: Container(
          child: Stack(
            children: [
              chatMessages(),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: messageTextEditingController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "type a message",
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.6))),
                      )),
                      GestureDetector(
                        onTap: () {
                          addMessage();
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
