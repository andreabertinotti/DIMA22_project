import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as pt;

class ChangeProPic extends StatefulWidget {
  String uid;
  ChangeProPic({Key? key, required this.uid}) : super(key: key);

  @override
  _ChangeProPicState createState() => _ChangeProPicState();
}

class _ChangeProPicState extends State<ChangeProPic> {
  File? img;
  var test_key = ValueKey("test_key");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      _pickImage().then((value) => setState(() {}));
                    },
                    child: const Text("+ add photo")),
                Container(
                  margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        _uploadImage(widget.uid).then((value) => {
                              setState(() {
                                Navigator.pop(context);
                              })
                            });
                      },
                      child: const Text("Upload photo")),
                ),
              ],
            ),
            Container(
              child: Text(
                img != null ? img.toString() : "",
                key: test_key,
              ),
              margin: EdgeInsets.fromLTRB(60, 20, 60, 0),
            ),
          ],
        ),
      ),
    );
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;
      final imagePath = File(image.path);

      this.img = imagePath;
    } on PlatformException catch (e) {
      print("Failed to pick image $e");
    }
  }

  Future _uploadImage(String uid) async {
    if (img == null) return;

    String name = pt.basename(img!.path);
    final destination = 'images/' + uid + "/" + name;
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage.ref(destination).putFile(img!).whenComplete(() => storage
          .ref(destination)
          .getDownloadURL()
          .then((value) =>
              FirebaseFirestore.instance.collection('User').doc(uid).update({
                "pic_url": value,
              })));
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }
  }
}
