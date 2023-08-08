import 'package:flutter/cupertino.dart';

class ImageView extends StatelessWidget {
  ImageView({Key? key, required this.map}) : super(key: key);
  Map<String, dynamic> map;

  @override
  Widget build(BuildContext context) {
    return map["urls"].length == 0
        ? Container()
        : SizedBox(
            height: 140.0,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: map["urls"].length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.network(
                  map["urls"][index],
                  width: 140,
                  height: 140,
                ),
              ),
            ),
          );
  }
}
