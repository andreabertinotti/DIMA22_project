import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationTileVertical extends StatelessWidget {
  const ReservationTileVertical({
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

  //final int price;
  // final Widget lockerImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 140,
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            Colors.orange, // Choose your desired border color
                        width: 2.0, // Adjust the border width as needed
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/square/$locker-locker-image-square.jpg'),
                        fit: BoxFit.cover, // Adjust the fit as needed
                      ),
                    ),
                  )),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // used 'intl' package for date format
                      "Drop-off: ${DateFormat('dd/MM/yyyy, HH:mm').format(dropOff)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      // used 'intl' package for date format
                      "Pick-up: ${DateFormat('dd/MM/yyyy, HH:mm').format(pickUp)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Duration: $duration hours",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Cell: $cell",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Price: $price",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: onDelete,
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
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
            ],
          ),
        )
      ],
    );
  }
}
