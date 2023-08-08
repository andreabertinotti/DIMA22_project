import 'package:flutter/material.dart';
import 'package:pro/Models/user_model.dart';
import 'package:pro/Services/auth_service.dart';
import 'package:pro/Social/PostDetails/flat_details_view.dart';
import 'package:pro/Social/PostDetails/flat_details_view_horizontal.dart';
import 'package:provider/provider.dart';

class PostDetails extends StatefulWidget {
  Map<String, dynamic> data;
  String docId;

  PostDetails(this.data, this.docId, {Key? key}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;

            return MediaQuery.of(context).size.width > 700
                ? FlatDetailsViewHorizontal(widget.data['flatId'],
                    data: widget.data, docId: widget.docId, user: user!)
                : FlatDetailsView(widget.data['flatId'],
                    data: widget.data, docId: widget.docId, user: user!);
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
