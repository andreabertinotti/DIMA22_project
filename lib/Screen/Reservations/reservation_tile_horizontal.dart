import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationTileHorizontal extends StatelessWidget {
  const ReservationTileHorizontal({
    super.key,
    required this.dropOff,
    required this.pickUp,
    required this.locker,
    required this.cell,
    required this.duration,
    required this.reservationId,
    required this.onDelete,
    required this.price,
    // required this.lockerImage
  });

  final DateTime dropOff;
  final DateTime pickUp;
  final String price;
  final String locker;
  final String cell;
  final int duration;
  final String reservationId;
  final VoidCallback onDelete;

  // final Widget lockerImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.05,
          ),
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.orange,
              width: 2.0,
            ),
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/square/$locker-locker-image-square.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.075,
                        MediaQuery.of(context).size.width * 0.025,
                        MediaQuery.of(context).size.width * 0.075,
                        0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Drop-off: ${DateFormat('dd/MM/yyyy, HH:mm').format(dropOff)}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Pick-up: ${DateFormat('dd/MM/yyyy, HH:mm').format(pickUp)}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.075,
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.075,
                        0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Duration: $duration hours",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            )),
                        Text("Cell: $cell",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.075,
                        MediaQuery.of(context).size.width * 0.01,
                        MediaQuery.of(context).size.width * 0.075,
                        0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Price: $price",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700])),
                      ],
                    )),
              ],
            )),
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
          child: ElevatedButton.icon(
            onPressed: onDelete,
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orange),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(color: Colors.orange)))),
            icon: Icon(Icons.delete, color: Colors.white),
            label: Text(
              "Delete booking",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
