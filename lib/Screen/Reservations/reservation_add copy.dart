import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class EditBooking extends StatefulWidget {
  EditBooking({Key? key, required this.uid}) : super(key: key);

  String uid;

  @override
  _EditBookingState createState() => _EditBookingState();
}

class _EditBookingState extends State<EditBooking> {
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
  String lockerName = 'Select a locker';
  String baggageSize = 'Select a size';
  String selectedCell = 'Select a cell';
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
  String lockerFee = ''; // Initialize with an empty string

// Update cell fare
  void _updateCellFare() async {
    cellFare = await retrieveCellFare(lockerName, selectedCell, duration);
    setState(() {});
  }

// Update locker fee
  void _updateLockerFee() async {
    lockerFee = await retrieveLockerFee(lockerName);
    setState(() {});
  }

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
    DocumentSnapshot lockerSnapshot = await FirebaseFirestore.instance
        .collection('lockers')
        .doc(locker)
        .get();

    String fee = lockerSnapshot['lockerFee'].toString();
    String renderedFee = '$fee€';
    return renderedFee;
  }

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

  List<DropdownMenuItem<String>> get dropdownLockers {
    List<DropdownMenuItem<String>> menuLockers = [
      DropdownMenuItem(
          value: 'Select a locker', child: Text('Select a locker')),
      DropdownMenuItem(value: "Leonardo", child: Text("Leonardo")),
      DropdownMenuItem(value: "Duomo", child: Text("Duomo")),
      DropdownMenuItem(value: "Bovisa", child: Text("Bovisa")),
      DropdownMenuItem(value: "Centrale", child: Text("Centrale")),
      DropdownMenuItem(value: "Garibaldi", child: Text("Garibaldi")),
      DropdownMenuItem(value: "Darsena", child: Text("Darsena")),
    ];
    return menuLockers;
  }

  // Widget to build the Drop-off date and time fields
  Padding buildDropOffField() {
    List<DropdownMenuItem<int>> dropdownHours = List.generate(24, (index) {
      return DropdownMenuItem<int>(
        value: index,
        child: Text(index.toString().padLeft(2, '0')),
      );
    });

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
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
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  icon:
                      Icon(Icons.calendar_month_outlined, color: Colors.black),
                ),
              ),
              Container(
                width: 15,
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
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  underline: Container(), // Remove the default underline
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Padding buildAvailabilityButton() {
    List<String> targetSlots =
        generateReservedSlots(dropoff, dropoffTime.hour, duration);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Check available cells:",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          lockerName == 'Select a locker'
              ? ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Please select the locker."),
                          content: Text(
                              "You need to select the locker before checking availability."),
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
                  child: Text("Select a locker"),
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
                                child: Text("OK"),
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
                                    print('available cells: ' +
                                        available_cells.toString());
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text("Confirm"),
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
          _updateLockerFee();
          //print(lockerName + selectedCell);
          print('locker fee: ' + lockerFee);
          print('cell fare: ' + cellFare);
        });
      },
      items: dropdownCells,
      style: TextStyle(color: Colors.black, fontSize: 18),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
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
      padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
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
            style: TextStyle(color: Colors.black, fontSize: 18),
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

  // Widget to build the Baggage Size field
  Padding buildSizeField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
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

  // Widget to build the Locker Address field
  Padding buildLockerAddressField() {
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
            child: DropdownButton<String>(
              hint: Text('Select a locker'),
              value: lockerName,
              onChanged: (String? newValue) {
                setState(() {
                  lockerName = newValue!;
                  availabilityChecked = false;
                  occupied_cells = [];
                });
              },
              items: dropdownLockers,
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build the entire screen
  @override
  Widget build(BuildContext context) {
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
              //buildPickUpField(), // Create fields through external methods above
              buildDurationField(),
              buildSizeField(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildAvailabilityButton(),
                  buildCellField(),
                ],
              ),

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
                  children: [Text("Locker fee:"), Text(lockerFee)],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Cell price:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(cellFare,
                        style: TextStyle(fontWeight: FontWeight.bold))
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
                      if (lockerName == 'Select a locker') {
                        // Show error message for locker name
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please select a locker'),
                        ));
                        return;
                      }

                      if (baggageSize == 'Select a size') {
                        // Show error message for baggage size
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please select a baggage size'),
                        ));
                        return;
                      }

                      if (bookingAuthorized == false) {
                        // Show error message for locker name
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Please complete your reservation before saving it!'),
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
                          'baggageSize': baggageSize,
                          'reservationStartDate': dropoff,
                          'reservationEndDate': pickup,
                          'reservationDuration': duration,
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
                        "\nSmall baggage: up to 60x40x25 cm\nLarge baggages: up to 80x55x40 cm\nDimensions are intended as:\nHEIGHT x WIDTH x DEPTH\n\nNotifications are sent to the user's device\none hour before the chosen pick-up time\n",
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
        ));
  }
}