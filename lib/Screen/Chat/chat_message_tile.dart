import 'package:flutter/material.dart';

class ChatMessageTile extends StatelessWidget {
  String message;
  bool sendByMe;
  ChatMessageTile(
      {Key? key, required String this.message, required bool this.sendByMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ),
          ),
        ),
      ],
    );
  }
}
