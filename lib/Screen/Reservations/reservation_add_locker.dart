import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:pro/Models/user_model.dart";
import 'package:provider/provider.dart';

import "../../Services/auth_service.dart";

class EditLockerBooking extends StatefulWidget {
  final dynamic document;

  const EditLockerBooking(this.document, {Key? key}) : super(key: key);

  @override
  _EditLockerBookingState createState() => _EditLockerBookingState();
}

class _EditLockerBookingState extends State<EditLockerBooking> {
  // GlobalKey used to access the ScaffoldMessengerState for displaying a Snackbar
  final GlobalKey<ScaffoldMessengerState> _bookingKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoading =
      false; // Indicates whether the application is still loading content

  // Default values for the reservation details, to be changed with booking data from the database
  //String dropdownValue = "Small"; // Default baggage size
  bool isNotificationActive =
      false; // Whether the notification is active or not
  DateTime dropoff =
      DateTime(2023, 1, 1, 12, 12); // Default drop-off date and time
  DateTime pickup =
      DateTime(2023, 12, 31, 23, 59); // Default pick-up date and time
  TimeOfDay dropoffTime =
      TimeOfDay(hour: 12, minute: 12); // Default drop-off time
  TimeOfDay pickupTime =
      TimeOfDay(hour: 23, minute: 59); // Default pick-up time
  String lockerName = 'Select a locker';
  String baggageSize = 'Select a size';

  /*
  @override
  void initState() {
    super.initState();
    getUser(); // Call the method to retrieve booking details from the database
  }
  */

  // Method to get the list of items to be shown in the baggage size dropdown menu
  List<DropdownMenuItem<String>> get dropdownSizes {
    List<DropdownMenuItem<String>> menuSizes = [
      DropdownMenuItem(value: 'Select a size', child: Text('Select a size')),
      DropdownMenuItem(value: "Small", child: Text("Small")),
      //DropdownMenuItem(value: "Medium", child: Text("Medium")),
      DropdownMenuItem(value: "Large", child: Text("Large")),
    ];
    return menuSizes;
  }

  //List<DropdownMenuItem<String>> get dropdownSelectedLocker {
  //  print(' +++++ locker id: ' + widget.document.id);
  //  return [
  //    DropdownMenuItem<String>(
  //      value: widget.document.id,
  //      child: Text(widget.document['lockerName']),
  //    ),
  //  ];
  //}

  /*
  // Method to retrieve booking details from the database
  getUser() async {
    // Page starts loading content
    setState(() {
      isLoading = true;
    });

    // TODO: Retrieve booking details from the database

    // Page ends loading content
    setState(() {
      isLoading = false;
    });
  }
  */

  // Widget to build the Drop-off date and time fields
  Padding buildDropOffField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Drop-off:",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Open the drop-off date picker when the button is pressed
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: dropoff,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          // Date picker theme customization
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.orange,
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.orange,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (newDate == null) {
                      return;
                    } // Do not save the date if the "cancel" button is pressed

                    // TODO: Update drop-off time and date in the database
                    else {
                      setState(() {
                        // Save the date if the "OK" button is pressed
                        dropoff = DateTime(newDate.year, newDate.month,
                            newDate.day, dropoff.hour, dropoff.minute);
                      });
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  label: Text(DateFormat('dd/MM/yyyy').format(dropoff),
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  icon:
                      Icon(Icons.calendar_month_outlined, color: Colors.black),
                ),
              ),
              Container(
                // Space between buttons
                width: 15,
              ),
              Expanded(
                flex: 4,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: dropoffTime,
                      initialEntryMode: TimePickerEntryMode.inputOnly,
                      builder: (context, child) {
                        return Theme(
                          // Time picker theme customization
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              onSurface: Colors.orange,
                              primary: Colors.orange,
                              onPrimary: Colors.white,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.orange,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (newTime == null) {
                      return;
                    } // Do not save the time if the "cancel" button is pressed
                    else {
                      setState(() {
                        // Save the time if the "OK" button is pressed
                        dropoff = DateTime(dropoff.year, dropoff.month,
                            dropoff.day, newTime.hour, newTime.minute);
                        dropoffTime = newTime;
                      });
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  label: Text(
                    DateFormat('HH:mm').format(dropoff),
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  icon: Icon(Icons.access_time, color: Colors.black),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Widget to build the Pick-up date and time fields
  Padding buildPickUpField() {
    // (Continued in next comment)
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pick-up:",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: pickup,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          // Date picker theme customization
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.orange,
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.orange,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (newDate == null) {
                      return;
                    } // Do not save the date if the "cancel" button is pressed

                    // TODO: Update pickup time and date in the database
                    else {
                      setState(() {
                        // Save the date if the "OK" button is pressed
                        pickup = DateTime(newDate.year, newDate.month,
                            newDate.day, pickup.hour, pickup.minute);
                      });
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  label: Text(DateFormat('dd/MM/yyyy').format(pickup),
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  icon:
                      Icon(Icons.calendar_month_outlined, color: Colors.black),
                ),
              ),
              Container(
                // Space between buttons
                width: 15,
              ),
              Expanded(
                flex: 4,
                child: ElevatedButton.icon(
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: pickupTime,
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        builder: (context, child) {
                          return Theme(
                            // Time picker theme customization
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                onSurface: Colors.orange,
                                primary: Colors.orange,
                                onPrimary: Colors.white,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.orange,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (newTime == null) {
                        return;
                      } // Do not save the time if the "cancel" button is pressed
                      else {
                        setState(() {
                          // Save the time if the "OK" button is pressed
                          pickup = DateTime(pickup.year, pickup.month,
                              pickup.day, newTime.hour, newTime.minute);
                          pickupTime = newTime;
                        });
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    label: Text(
                      DateFormat('HH:mm').format(pickup),
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    icon: Icon(Icons.access_time, color: Colors.black)),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Widget to build the Baggage Size field
  Padding buildSizeField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Baggage size:",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Container(
            //Space between text and dropdown
            width: 15,
          ),
          SizedBox(
              width: 200,
              child: DropdownButton<String>(
                hint: const Text("Select baggage size"),
                value: baggageSize,
                icon: const Icon(Icons.keyboard_arrow_down),
                style: TextStyle(fontSize: 18, color: Colors.black),
                onChanged: (String? newValue) {
                  // This is called when the user selects an item.
                  setState(() {
                    baggageSize = newValue!; //TODO: change also db value
                  });
                },
                items: dropdownSizes,
                isExpanded: true,
              ))
        ],
      ),
    );
  }

  Padding buildLockerAddressField() {
    String lockerName = widget.document['lockerName'];
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Locker name:",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {},
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        lockerName,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ))),
          ],
        ));
  }

  /*
  // Widget to build the Notification field
  Padding buildNotificationField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          width: 180,
          child: Text(
            "Send notification one hour before pick-up time:",
            maxLines: 3,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        Container(
          //Space between text and checkbox
          width: 15,
        ),
        Transform.scale(
            scale: 1.5,
            // Display checkbox to choose notification preference
            child: Checkbox(
              checkColor: Colors.white,
              activeColor: Colors.orange,
              value: isNotificationActive,
              onChanged: (bool? value) {
                setState(() {
                  isNotificationActive = value!; //TODO: change value on db
                });
              },
            ))
      ]),
    );
  }
  */

  //// Widget to build the Locker Address field
  //Padding buildLockerAddressField() {
  //  return Padding(
  //    padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
  //    child: Column(
  //      crossAxisAlignment: CrossAxisAlignment.start,
  //      children: [
  //        Text(
  //          "Locker name:",
  //          style: TextStyle(
  //            fontSize: 15,
  //          ),
  //        ),
  //        SizedBox(
  //          width: double.infinity,
  //          child: DropdownButton<String>(
  //            hint: Text('Select a locker'),
  //            value: lockerName,
  //            onChanged: (String? newValue) {
  //              setState(() {
  //                lockerName = newValue!;
  //              });
  //            },
  //            items: dropdownSelectedLocker,
  //            isExpanded: true,
  //          ),
  //        ),
  //      ],
  //    ),
  //  );
  //}

  // Widget to build the entire screen
  @override
  Widget build(BuildContext context) {
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
                : ScaffoldMessenger(
                    key: _bookingKey,
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.orange,
                        title: const Text(
                          'Add a new reservation',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      body: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(color: Colors.red),
                            ),
                          ),
                          buildLockerAddressField(),
                          buildDropOffField(),
                          buildPickUpField(), // Create fields through external methods above
                          buildSizeField(),
                          //buildNotificationField(),
                          Divider(
                            thickness: 1,
                            color: Colors.black,
                            indent: 20,
                            endIndent: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("$baggageSize baggage deposit"),
                                Text(
                                    "€6,99") // TODO: assign each size a price and automate price calculation
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text("Service fee"), Text("€2,00")],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total price",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("€${5.99 + 2.00}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.orange),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            side: BorderSide(
                                                color: Colors.orange)))),
                                onPressed: () {
                                  // Check for valid selections in dropdowns and date/time fields
                                  if (baggageSize == 'Select a size') {
                                    // Show error message for baggage size
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text('Please select a baggage size'),
                                    ));
                                    return;
                                  }

                                  if (lockerName == 'Select a locker') {
                                    // Show error message for locker name
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Please select a locker'),
                                    ));
                                    return;
                                  }

                                  // Add data to Firestore when all validations pass
                                  FirebaseFirestore.instance
                                      .collection('lockers')
                                      .doc('locker1')
                                      .collection('cells')
                                      .doc('cell1')
                                      .collection('reservations')
                                      .add({
                                    'userUid': user.uid,
                                    'locker': widget.document['lockerName'],
                                    'cell': 'cell1',
                                    'baggageSize': baggageSize,
                                    'reservationStartDate': dropoff,
                                    'reservationEndDate': pickup,
                                  });
                                },
                                child: Text("save booking".toUpperCase(),
                                    style: TextStyle(fontSize: 18)),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              // Display message with info about notification, prices, luggage sizes when "?" button is pressed
                              // TODO: add prices into tooltip message
                              Tooltip(
                                message:
                                    "\nSmall baggage: up to 60x40x25 cm\nLarge baggages: up to 80x55x40 cm\nDimensions are intended as:\nHEIGHT x WIDTH x DEPTH\n\nNotifications are sent to the user's device\none hour before the chosen pick-up time\n",
                                triggerMode: TooltipTriggerMode.tap,
                                textStyle: TextStyle(
                                    fontSize: 17, color: Colors.white),
                                textAlign: TextAlign.center,
                                showDuration: Duration(seconds: 10),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                  child: Center(
                                      child: Text("?",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white))),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
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
