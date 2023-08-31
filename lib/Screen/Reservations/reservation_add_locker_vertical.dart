import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:intl/intl.dart";
import 'package:provider/provider.dart';

import "../../Services/auth_service.dart";
import "../../Services/database_service.dart";

class EditLockerBooking extends StatefulWidget {
  final dynamic document;
  final String uid;

  const EditLockerBooking(this.document, {Key? key, required this.uid})
      : super(key: key);

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
  bool isNotificationActive =
      false; // Whether the notification is active or not
  DateTime dropoff = DateTime.now(); // Default drop-off date and time
  DateTime pickup = DateTime.now(); // Default pick-up date and time
  TimeOfDay dropoffTime =
      TimeOfDay(hour: 12, minute: 00); // Default drop-off time
  TimeOfDay pickupTime =
      TimeOfDay(hour: 23, minute: 59); // Default pick-up time
  //String lockerName = 'Select a locker';
  String selectedCell = 'Select a cell';
  String serviceLockerName = '';
  int duration = 0;
  bool availabilityChecked = false;
  bool bookingAuthorized = false;
  List all_cells = [
    'Select a cell',
    'cell 1 (small)',
    'cell 2 (small)',
    'cell 3 (large)'
  ];
  List occupied_cells = [];
  List available_cells = [];

  String cellFare = '';
  String lockerAddress = '';

// Update cell fare
  void _updateCellFare() async {
    //print(serviceLockerName);
    cellFare = await retrieveCellFare(
        serviceLockerName, selectedCell, duration, bookingAuthorized);
    setState(() {});
  }

  /*
  @override
  void initState() {
    super.initState();
    getUser(); // Call the method to retrieve booking details from the database
  }
  */

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
    List<DropdownMenuItem<int>> dropdownHours = List.generate(24, (index) {
      return DropdownMenuItem<int>(
        value: index,
        child: Text(index.toString().padLeft(2, '0')),
      );
    });

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Drop-off date and time:",
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
                      initialDate: dropoff,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
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
                    }

                    setState(() {
                      dropoff = DateTime(newDate.year, newDate.month,
                          newDate.day, dropoffTime.hour, 0);
                      pickup =
                          dropoff.add(Duration(hours: duration, minutes: -1));
                      availabilityChecked = false;
                      cellFare = '';
                      occupied_cells = [];
                    });
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  label: Text(
                    DateFormat('dd/MM/yyyy').format(dropoff),
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  icon:
                      Icon(Icons.calendar_month_outlined, color: Colors.black),
                ),
              ),
              Container(
                width: 20,
              ),
              Expanded(
                flex: 4,
                child: DropdownButton<int>(
                  icon: const Icon(Icons.access_time),
                  borderRadius: BorderRadius.circular(10),
                  value: dropoffTime.hour,
                  onChanged: (int? newValue) {
                    setState(() {
                      dropoff = DateTime(dropoff.year, dropoff.month,
                          dropoff.day, newValue!, 0);
                      dropoffTime = TimeOfDay(hour: newValue, minute: 0);
                      availabilityChecked = false;
                      cellFare = '';
                      occupied_cells = [];
                    });
                  },
                  items: dropdownHours,
                  menuMaxHeight: MediaQuery.of(context).size.height * 0.4,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  isExpanded: true,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Padding buildAvailabilityButton() {
    String lockerName = widget.document['lockerName'];
    List<String> targetSlots =
        generateReservedSlots(dropoff, dropoffTime.hour, duration);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Check available cells:",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          (duration == 0)
              ? ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Please fill the information above"),
                          content: Text(
                              "You need to select the date and a valid duration before checking availability."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade300),
                  ),
                  child: Text("Fill the form"),
                )
              : ElevatedButton(
                  onPressed: () {
                    DateTime currentDate = DateTime.now();
                    if (dropoff.isBefore(currentDate)) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Invalid Date"),
                            content: Text(
                                "You can't make a reservation in the past!"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Check availability"),
                            content: Text(
                                "Do you want to check for availability in the selected date and locker?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  QuerySnapshot querySnapshot =
                                      await FirebaseFirestore.instance
                                          .collectionGroup('bookedSlots')
                                          .where('locker',
                                              isEqualTo: lockerName)
                                          .where('timeSlot',
                                              whereIn: targetSlots)
                                          .get();

                                  for (QueryDocumentSnapshot bookedSlotSnap
                                      in querySnapshot.docs) {
                                    occupied_cells.add(bookedSlotSnap['cell']);
                                  }
                                  occupied_cells =
                                      occupied_cells.toSet().toList();

                                  setState(() {
                                    availabilityChecked = true;
                                    selectedCell = 'Select a cell';
                                    available_cells = all_cells
                                        .toSet()
                                        .difference(occupied_cells.toSet())
                                        .toList();
                                    //  print('available cells: ' +
                                    //      available_cells.toString());
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Confirm",
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green.shade400),
                  ),
                  child: Text("Check availability"),
                ),
        ],
      ),
    );
  }

  Padding buildCellField() {
    List<DropdownMenuItem<String>> dropdownCells = available_cells.map((cell) {
      return DropdownMenuItem<String>(
        value: cell,
        child: Text(cell),
      );
    }).toList();

    Widget cellDropdown = DropdownButton<String>(
      value: selectedCell,
      onChanged: (String? newValue) async {
        setState(() {
          selectedCell = newValue!;
          selectedCell == 'Select a cell'
              ? bookingAuthorized = false
              : bookingAuthorized = true;

          // Call the auxiliary functions to update fee state variables
          _updateCellFare();
          //_updateLockerFee();
          //print(widget.document['lockerName'] + selectedCell);

          //    print('cell fare: ' + cellFare);
        });
      },
      items: dropdownCells,
      style: TextStyle(color: Colors.black, fontSize: 18),
    );
    //print(availabilityChecked);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Select available cell:",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          availabilityChecked == false
              ? ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              "Fill the information about your reservation"),
                          content: Text(
                              "You need to fill the reservation form and check for availability before selecting a cell."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade300),
                  ),
                  child: Text("Fill other fields"),
                )
              : (available_cells.length ==
                      1 // case in which it contains only 'Select a cell'
                  ? ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("We're sorry!"),
                              content: Text(
                                  "Unfortunately there are no cells available in this locker for the selected time slots"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
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
                      child: Text("NO CELLS AVAILABLE"),
                    )
                  : cellDropdown),
        ],
      ),
    );
  }

// Widget to build the Pick-up date and time fields
  Padding buildDurationField() {
    List<DropdownMenuItem<int>> dropdownDurations = List.generate(24, (index) {
      return DropdownMenuItem<int>(
        value: index, // Values from 1 to 24
        child: Text('${index} hour${index != 1 ? 's' : ''}'),
      );
    });

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Booking duration:",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          DropdownButton<int>(
            borderRadius: BorderRadius.circular(10),
            value: duration,
            onChanged: (int? newValue) {
              setState(() {
                duration = newValue!;
                pickup = dropoff.add(Duration(hours: duration, minutes: -1));
                availabilityChecked = false;
                occupied_cells = [];
                cellFare = '';
              });
            },
            items: dropdownDurations,
            menuMaxHeight: MediaQuery.of(context).size.height * 0.4,
            style: TextStyle(color: Colors.black, fontSize: 18),
            underline: Container(), // Remove the default underline
          ),
        ],
      ),
    );
  }

  List<String> generateReservedSlots(
      DateTime dropoffDate, int dropoffHour, int duration) {
    // print(dropoffHour);
    List<String> reservedSlots = [];

    for (int i = 0; i < duration; i++) {
      DateTime slotDateTime = dropoffDate.add(Duration(hours: i));
      String slot = DateFormat('yyyyMMddHH').format(slotDateTime);
      reservedSlots.add(slot);
      //print(slot);
    }

    return reservedSlots;
  }

  Padding buildLockerAddressField() {
    String lockerName = widget.document['lockerName'];
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
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

  // Widget to build the entire screen
  @override
  Widget build(BuildContext context) {
    serviceLockerName = widget.document['lockerName'];
    //final authService = Provider.of<AuthService>(context);
    String lockerName = widget.document['lockerName'];
    lockerAddress = widget.document['lockerAddress'];
    return ScaffoldMessenger(
        key: _bookingKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            title: const Text(
              'Add a new reservation',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.orange, width: 3.0)),
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/wide/$lockerName-locker-image-wide.jpg'),
                            fit: BoxFit.cover)),
                  ),
                ),
                buildLockerAddressField(),
                buildDropOffField(),
                buildDurationField(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildAvailabilityButton(),
                    buildCellField(),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Locker Address:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(lockerAddress,
                              style: TextStyle(fontWeight: FontWeight.w400))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Price to pay:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(cellFare,
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
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
                      onPressed: () async {
                        // Check for valid selections in dropdowns and date/time fields
                        //if (lockerName == 'Select a locker') {
                        //  // Show error message for locker name
                        //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //    content: Text('Please select a locker'),
                        //  ));
                        //  return;
                        //}

                        // if (baggageSize == 'Select a size') {
                        //   // Show error message for baggage size
                        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //     content: Text('Please select a baggage size'),
                        //   ));
                        //   return;
                        // }

                        if (bookingAuthorized == false) {
                          // Show error message for locker name
                          _bookingKey.currentState?.showSnackBar(SnackBar(
                            content: Text(
                                'Please complete your reservation before saving it!'),
                            backgroundColor: Colors.red,
                          ));
                          return;
                        }

                        // Generate reserved slots
                        List<String> reservedSlots = generateReservedSlots(
                            dropoff, dropoffTime.hour, duration);

                        await FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          // Create the reservation document
                          final reservationRef = FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.uid)
                              .collection('reservations')
                              .doc();

                          final reservationData = {
                            'userUid': widget.uid,
                            'locker': lockerName,
                            'cell': selectedCell,
                            'reservationStartDate': dropoff,
                            'reservationEndDate': pickup,
                            'reservationDuration': duration,
                            'reservationPrice': cellFare,
                            'lockerAddress': lockerAddress,
                          };

                          transaction.set(reservationRef, reservationData);

                          // Add bookedSlot documents to the corresponding locker and cell
                          final lockerRef = FirebaseFirestore.instance
                              .collection('lockers')
                              .doc(lockerName)
                              .collection('cells')
                              .doc(selectedCell);

                          for (String slot in reservedSlots) {
                            final bookedSlotRef =
                                lockerRef.collection('bookedSlots').doc(slot);

                            final bookedSlotData = {
                              'locker': lockerName,
                              'cell': selectedCell,
                              'timeSlot': slot,
                              'linkedReservation': reservationRef.id,
                            };

                            transaction.set(bookedSlotRef, bookedSlotData);
                          }
                        });

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Booking saved!'),
                          backgroundColor: Colors.green,
                        ));

                        Navigator.of(context).pop();
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
                          "\nSmall cells can store baggages up to:\n60x40x25 cm\n\nLarge cells can store baggages up to:\n80x55x40 cm\n\nDimensions are intended as:\nHEIGHT x WIDTH x DEPTH\n",
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: TextStyle(fontSize: 17, color: Colors.white),
                      textAlign: TextAlign.center,
                      showDuration: Duration(seconds: 10),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                        child: Center(
                            child: Text("?",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white))),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
    //     } else {
    //       return const Scaffold(
    //         body: Center(
    //           child: CircularProgressIndicator(),
    //         ),
    //       );
    //     }
    //   });
  }
}