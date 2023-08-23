// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:intl/intl.dart";
import "package:pro/Models/user_model.dart";
import 'package:provider/provider.dart';

import "../../Services/auth_service.dart";

class AddLockerBookingTablet extends StatefulWidget {
  final dynamic document;
  final String uid;

  const AddLockerBookingTablet(this.document, {Key? key, required this.uid})
      : super(key: key);

  @override
  _AddLockerBookingTabState createState() => _AddLockerBookingTabState();
}

class _AddLockerBookingTabState extends State<AddLockerBookingTablet> {
  // GlobalKey used to access the ScaffoldMessengerState for displaying a Snackbar
  final GlobalKey<ScaffoldMessengerState> _bookingKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoading =
      false; // Indicates whether the application is still loading content

  // Default values for the reservation details, to be changed with booking data from the database
  //String dropdownValue = "Small"; // Default baggage size
  bool isNotificationActive =
      false; // Whether the notification is active or not
  DateTime dropoff = DateTime.now(); // Default drop-off date and time
  DateTime pickup = DateTime.now(); // Default pick-up date and time
  TimeOfDay dropoffTime =
      TimeOfDay(hour: 12, minute: 12); // Default drop-off time
  TimeOfDay pickupTime =
      TimeOfDay(hour: 23, minute: 59); // Default pick-up time
  //String lockerName = 'Select a locker';
  String baggageSize = 'Select a size';
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

  String cellFare = ''; // Initialize with an empty string
  //String lockerFee = ''; // Initialize with an empty string

// Update cell fare
  void _updateCellFare() async {
    print(serviceLockerName);
    cellFare =
        await retrieveCellFare(serviceLockerName, selectedCell, duration);
    setState(() {});
  }

// Update locker fee
  // void _updateLockerFee() async {
  //   lockerFee = await retrieveLockerFee(widget.document['lockerName']);
  //   setState(() {});
  // }
//
  Future<String> retrieveCellFare(
      String locker, String cell, int duration) async {
    if (!bookingAuthorized) {
      return '';
    }
    DocumentSnapshot cellSnapshot = await FirebaseFirestore.instance
        .collection('lockers')
        .doc(locker)
        .collection('cells')
        .doc(cell)
        .get();

    double cellFare = cellSnapshot['cellFare'] as double;
    String fare = (cellFare * duration).toStringAsFixed(2);
    String renderedFare = '$fare€';
    return renderedFare;
  }

  Future<String> retrieveLockerFee(String locker) async {
    if (locker == 'Select a locker') {
      return '';
    }
    //DocumentSnapshot lockerSnapshot = await FirebaseFirestore.instance
    //    .collection('lockers')
    //    .doc(locker)
    //    .get();

    String fee = '0'; //lockerSnapshot['lockerFee'].toString();
    String renderedFee = '$fee€';
    return renderedFee;
  }

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

  //List<DropdownMenuItem<String>> get dropdownLockers {
  //  List<DropdownMenuItem<String>> menuLockers = [
  //    DropdownMenuItem(
  //        value: 'Select a locker', child: Text('Select a locker')),
  //    DropdownMenuItem(value: "locker1", child: Text("Leonardo")),
  //    DropdownMenuItem(value: "locker2", child: Text("Duomo")),
  //    DropdownMenuItem(value: "locker3", child: Text("Bovisa")),
  //    DropdownMenuItem(value: "locker4", child: Text("Centrale")),
  //    DropdownMenuItem(value: "locker5", child: Text("Garibaldi")),
  //    DropdownMenuItem(value: "locker6", child: Text("Darsena")),
  //  ];
  //  return menuLockers;
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
    List<DropdownMenuItem<int>> dropdownHours = List.generate(24, (index) {
      return DropdownMenuItem<int>(
        value: index,
        child: Text(index.toString().padLeft(2, '0')),
      );
    });

    return Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.03,
          MediaQuery.of(context).size.width * 0.02,
          MediaQuery.of(context).size.width * 0.03,
          0),
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
                      dropoff = DateTime(
                          newDate.year, newDate.month, newDate.day, 12, 0);
                      pickup =
                          dropoff.add(Duration(hours: duration, minutes: -1));
                      availabilityChecked = false;
                      occupied_cells = [];
                    });
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  label: Text(
                    DateFormat('dd/MM/yyyy').format(dropoff),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  icon:
                      Icon(Icons.calendar_month_outlined, color: Colors.black),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.04,
              ),
              Expanded(
                flex: 4,
                child: DropdownButton<int>(
                  value: dropoffTime.hour,
                  onChanged: (int? newValue) {
                    setState(() {
                      dropoff = DateTime(dropoff.year, dropoff.month,
                          dropoff.day, newValue!, 0);
                      dropoffTime = TimeOfDay(hour: newValue, minute: 0);
                      availabilityChecked = false;
                      occupied_cells = [];
                    });
                  },
                  items: dropdownHours,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  isExpanded: true,
                  //underline: Container(), // Remove the default underline
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
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.03,
          MediaQuery.of(context).size.width * 0.03,
          MediaQuery.of(context).size.width * 0.03,
          MediaQuery.of(context).size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Check available cells:",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.005),
          ElevatedButton(
            onPressed: () {
              DateTime currentDate = DateTime.now();
              if (dropoff.isBefore(currentDate)) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Invalid Date"),
                      content:
                          Text("You can't make a reservation in the past!"),
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
                                    .where('locker', isEqualTo: lockerName)
                                    .where('timeSlot', whereIn: targetSlots)
                                    .get();

                            for (QueryDocumentSnapshot bookedSlotSnap
                                in querySnapshot.docs) {
                              occupied_cells.add(bookedSlotSnap['cell']);
                            }
                            occupied_cells = occupied_cells.toSet().toList();

                            setState(() {
                              availabilityChecked = true;
                              selectedCell = 'Select a cell';
                              available_cells = all_cells
                                  .toSet()
                                  .difference(occupied_cells.toSet())
                                  .toList();
                              print('available cells: ' +
                                  available_cells.toString());
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
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.green.shade400),
            ),
            child: Text(
              "Check availability",
              style: TextStyle(fontSize: 20),
            ),
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

          print('cell fare: ' + cellFare);
        });
      },
      items: dropdownCells,
      style: TextStyle(color: Colors.black, fontSize: 20),
    );
    //print(availabilityChecked);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.03,
          MediaQuery.of(context).size.width * 0.03,
          MediaQuery.of(context).size.width * 0.03,
          MediaQuery.of(context).size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Select available cell:",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.005),
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
                  child: Text(
                    "Fill other fields",
                    style: TextStyle(fontSize: 20),
                  ),
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
                      child: Text(
                        "NO CELLS AVAILABLE",
                        style: TextStyle(fontSize: 20),
                      ),
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
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.03,
          MediaQuery.of(context).size.width * 0.02,
          MediaQuery.of(context).size.width * 0.03,
          0),
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
            width: MediaQuery.of(context).size.width * 0.02,
          ),
          DropdownButton<int>(
            value: duration,
            onChanged: (int? newValue) {
              setState(() {
                duration = newValue!;
                pickup = dropoff.add(Duration(hours: duration, minutes: -1));
                availabilityChecked = false;
                occupied_cells = [];
              });
            },
            items: dropdownDurations,
            style: TextStyle(color: Colors.black, fontSize: 20),
            menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
        ],
      ),
    );
  }

  List<String> generateReservedSlots(
      DateTime dropoffDate, int dropoffHour, int duration) {
    print(dropoffHour);
    List<String> reservedSlots = [];

    for (int i = 0; i < duration; i++) {
      DateTime slotDateTime = dropoffDate.add(Duration(hours: i));
      String slot = DateFormat('yyyyMMddHH').format(slotDateTime);
      reservedSlots.add(slot);
      //print(slot);
    }

    return reservedSlots;
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

  Padding buildLockerAddressField() {
    String lockerName = widget.document['lockerName'];
    return Padding(
        padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.03,
            MediaQuery.of(context).size.width * 0.05,
            MediaQuery.of(context).size.width * 0.03,
            0),
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
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ))),
          ],
        ));
  }

  // Widget to build the entire screen
  @override
  Widget build(BuildContext context) {
    serviceLockerName = widget.document['lockerName'];
    final authService = Provider.of<AuthService>(context);
    String lockerName = widget.document['lockerName'];
    return ScaffoldMessenger(
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
          body: Row(
            children: [
              Flexible(
                  child: Column(
                children: [
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
                  //buildNotificationField(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                                        borderRadius: BorderRadius.circular(18),
                                        side:
                                            BorderSide(color: Colors.orange)))),
                            onPressed: () async {
                              if (baggageSize == 'Select a size') {
                                // Show error message for baggage size
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Please select a baggage size'),
                                ));
                                return;
                              }

                              if (bookingAuthorized == false) {
                                // Show error message for locker name
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Please complete your reservation before saving it!'),
                                ));
                                return;
                              }

                              // Generate reserved slots
                              List<String> reservedSlots =
                                  generateReservedSlots(
                                      dropoff, dropoffTime.hour, duration);

                              await FirebaseFirestore.instance
                                  .runTransaction((transaction) async {
                                // Create the reservation document
                                final reservationRef = FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(widget.uid)
                                    .collection('reservations')
                                    .doc();

                                final reservationData = {
                                  'userUid': widget.uid,
                                  'locker': lockerName,
                                  'cell': selectedCell,
                                  'baggageSize': baggageSize,
                                  'reservationStartDate': dropoff,
                                  'reservationEndDate': pickup,
                                  'reservationDuration': duration,
                                };

                                transaction.set(
                                    reservationRef, reservationData);

                                // Add bookedSlot documents to the corresponding locker and cell
                                final lockerRef = FirebaseFirestore.instance
                                    .collection('lockers')
                                    .doc(lockerName)
                                    .collection('cells')
                                    .doc(selectedCell);

                                for (String slot in reservedSlots) {
                                  final bookedSlotRef = lockerRef
                                      .collection('bookedSlots')
                                      .doc(slot);

                                  final bookedSlotData = {
                                    'locker': lockerName,
                                    'cell': selectedCell,
                                    'timeSlot': slot,
                                    'linkedReservation': reservationRef.id,
                                  };

                                  transaction.set(
                                      bookedSlotRef, bookedSlotData);
                                }
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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
                                "\nSmall baggage: up to 60x40x25 cm\nLarge baggages: up to 80x55x40 cm\nDimensions are intended as:\nHEIGHT x WIDTH x DEPTH\n\nNotifications are sent to the user's device\none hour before the chosen pick-up time\n",
                            triggerMode: TooltipTriggerMode.tap,
                            textStyle:
                                TextStyle(fontSize: 17, color: Colors.white),
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
                  )
                ],
              )),
              Flexible(
                  child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 15.0, // soften the shadow
                      spreadRadius: 5.0, //extend the shadow
                      offset: Offset(
                        5.0, // Move to right 5  horizontally
                        5.0, // Move to bottom 5 Vertically
                      ),
                    )
                  ],
                ),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30, bottom: 20),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(color: Colors.red),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.black,
                      indent: MediaQuery.of(context).size.width * 0.035,
                      endIndent: MediaQuery.of(context).size.width * 0.035,
                    ),
                    Column(
                      children: [
                        /* Padding(                                       //TODO: layout prezzi preso da reservation_add_tablet.dart (da sistemare)
                                        padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context).size.width * 0.035, 
                                          vertical: MediaQuery.of(context).size.width * 0.01,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "${baggageSize == 'Select a size' ? "Baggage deposit" : "$baggageSize baggage deposit"}",
                                                style: TextStyle(fontSize: 18),),
                                            Text(
                                                "€6,99",
                                                style: TextStyle(fontSize: 18),) // TODO: assign each size a price and automate price calculation
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context).size.width * 0.035, 
                                          vertical: MediaQuery.of(context).size.width * 0.01,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [Text("Service fee", style: TextStyle(fontSize: 18),), Text("€2,00", style: TextStyle(fontSize: 18),)],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          MediaQuery.of(context).size.width * 0.035, MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.width * 0.035, MediaQuery.of(context).size.width * 0.035
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Total price",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                            Text("€${5.99 + 2.00}",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                                          ],
                                        ),
                                      ), */
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Price to pay:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text(cellFare,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18))
                            ],
                          ),
                        ),
                        //Padding(
                        //  padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                        //  child: Row(
                        //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //    children: [Text("Locker fee:"), Text(lockerFee)],
                        //  ),
                        //),
                      ],
                    )
                  ],
                ),
              ))
            ],
          )),
    );
    //    } else {
    //      return const Scaffold(
    //        body: Center(
    //          child: CircularProgressIndicator(),
    //        ),
    //      );
    //    }
  }
}
