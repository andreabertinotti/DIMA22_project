import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro/Services/auth_service.dart';
import 'package:provider/provider.dart';

import '../Models/user_model.dart';

class CreatePost extends StatefulWidget {
  final dynamic document;

  const CreatePost(this.document, {Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final postTitleController = TextEditingController();
  final postContentController = TextEditingController();

  @override
  void dispose() {
    postTitleController.dispose();
    postContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String flatTitle = widget.document['name'];
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;

            return user == null
                ? Container(
                    child: Scaffold(
                        body: Center(child: Text("You have to be logged in!"))),
                  )
                : Scaffold(
                    body: Container(
                    margin: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(5, 0, 120, 0),
                            child: Text(
                              'Create a Post linked to \n $flatTitle',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 30, 20, 5),
                            child: TextFormField(
                              controller: postTitleController,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: "post title",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFF000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFF000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 5, 20, 5),
                            child: TextFormField(
                              controller: postContentController,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'post content',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFF000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFF000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                250, 75, 5, 0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('Post')
                                      .add({
                                    "uid": user.uid,
                                    "title": postTitleController.text,
                                    "content": postContentController.text,
                                    "userMail": user.email,
                                    "flatId": widget.document.id,
                                  });
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Confirm'),
                            ),
                          ),
                        ]),
                  ));
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
