// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:pro/Utils/image_view.dart';
import 'bookingLockerWrapper_horizontalView.dart';
import 'constants.dart';

class CustomDialogBox extends StatefulWidget {
  final dynamic document;
  final Map<String, dynamic> map;

  CustomDialogBox({
    Key? key,
    required this.document,
    required this.map,
  }) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Dialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          width: 435,
          height: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 4,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 15, top: 15),
                              child: Text(
                                "${widget.document['lockerName'].toString()} locker",
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Address: ${widget.document['lockerAddress'].toString()}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Locker fee: ${widget.document['lockerFee'].toString()}€",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5, left: 15),
                              child: Text(
                                "Small cell fare: ${widget.document['smallCellFare'].toString()}€/hour",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                              child: Text(
                                "Large cell fare: ${widget.document['largeCellFare'].toString()}€/hour",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(top: 15, right: 15),
                        height: 155,
                        width: 155,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.orange, width: 3.0),
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/${widget.document['lockerName'].toString()}-locker-image.png'),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 15),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  BookingLockerHorizontalWrapper(
                                      (widget.document))))).then((_) {
                        Navigator.of(context)
                            .pop(); // Close the dialog box after returning from BookingLockerHorizontalWrapper
                      });
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.orange),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: BorderSide(color: Colors.orange)))),
                    child: Text("Book this locker".toUpperCase())),
              ),
              widget.map.containsKey("urls") == true
                  ? ImageView(
                      map: widget.map,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
