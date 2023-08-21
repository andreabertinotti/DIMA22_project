// ignore_for_file: prefer_const_constructors

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
            MediaQuery.of(context).size.width / 2,            //TODO: check these values and fix dimensions of the box
            MediaQuery.of(context).size.height / 1.5),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, left: 5, top: 15),
                        child: Text(
                          "${widget.document['lockerName'].toString()} locker",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Address: ${widget.document['lockerAddress'].toString()}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          "Locker fee: ${widget.document['lockerFee'].toString()}€",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 5),
                        child: Text(
                          "Small cell fare: ${widget.document['smallCellFare'].toString()}€/hour",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 0, 10),
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
                  SizedBox(width: 50,),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    height: 135,
                    width: 135,
                    decoration: BoxDecoration(color: Colors.red),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(
                      builder: ((context) => Wrapper( widget:EditLockerBooking(widget.document)))
                    ));
                  }, 
                  style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.orange),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: BorderSide(color: Colors.orange)))),
                  child: Text("Book this locker".toUpperCase())
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
