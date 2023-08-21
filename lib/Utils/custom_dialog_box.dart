import 'package:flutter/material.dart';
import 'package:pro/Utils/image_view.dart';
import 'package:pro/Utils/wrapper.dart';

import '../Screen/Reservations/reservation_add_locker copy.dart';
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
        insetPadding: EdgeInsets.fromLTRB(
            0,
            0,
            MediaQuery.of(context).size.width / 1.75,
            MediaQuery.of(context).size.height / 1.6),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => Wrapper(
                                    widget:
                                        EditLockerBooking(widget.document)))));
                      },
                      color: Color(0xFFFF9800),
                      textColor: Colors.white,
                      child: const Text("Create a reservation"),
                    ),
                  ],
                ),
              ),

              ///// MAYBE ADD A MARGIN TO THE ROWS BELOW
              ///
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text(
                  "${widget.document['lockerName'].toString()} locker",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              //Row(
              //  children: [
              //    const Text(
              //      "Locker's name: ",
              //      style: TextStyle(
              //        fontSize: 17,
              //        fontWeight: FontWeight.w600,
              //      ),
              //    ),
              //    Text(
              //      widget.document['lockerName'],
              //      style: const TextStyle(
              //        fontSize: 17,
              //        fontWeight: FontWeight.w400,
              //      ),
              //    ),
              //  ],
              //),

              // Row(
              //   children: [
              //     const Text(
              //       "euro/hour: ",
              //       style: TextStyle(
              //         fontSize: 17,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //     Text(
              //       widget.document['lockerFare'].toString(),
              //       style: const TextStyle(
              //         fontSize: 17,
              //         fontWeight: FontWeight.w400,
              //       ),
              //     ),
              //   ],
              // ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Address: ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.document['lockerAddress'],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Padding(
              //  padding: EdgeInsets.only(top: 10),
              //  child: Text(
              //    "Locker fee: ${widget.document['lockerFee'].toString()}€",
              //    style: const TextStyle(
              //      fontSize: 14,
              //      fontWeight: FontWeight.w400,
              //    ),
              //  ),
              //),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  "Small cell fare: ${widget.document['smallCellFare'].toString()}€/hour",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Text(
                  "Large cell fare: ${widget.document['largeCellFare'].toString()}€/hour",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              //],
              // ),
              // ),

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
