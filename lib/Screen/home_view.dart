// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../Utils/bookingLockerWrapper.dart';
import '../Utils/custom_dialog_box.dart';
import '../Utils/image_view.dart';
import '../Utils/info_screen_wrapper.dart';
import '../Utils/wrapper.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Set<Marker> markers = Set();
  late BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  var user_location = Location();
  LocationData? currentLocation;
  late var initial_location;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  bool ok = true;

  @override
  void initState() {
    getIcons();
    super.initState();
    _check_permission();
    if (ok) {
      user_location.onLocationChanged.listen((value) {
        if (!mounted) return;
        setState(() {
          currentLocation = value;
        });
      });
    }
  }

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
          devicePixelRatio: 3.0,
          size: Size(37, 50)), //marker size scaled by 0.5x (original: 74x100)
      "assets/images/marker.png",
    );
    // temptative condition to avoid exceptions
    if (!mounted) return;
    setState(() {
      this.customIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF9800),
          foregroundColor: Colors.white,
          title: const Text(
            'Milan Lockers', //Change app name (?)
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Wrapper(widget: MenuWrapper())));
                },
                icon: Icon(
                  Icons.question_mark,
                  color: Colors.white,
                ),
                label: Text("",
                    style: TextStyle(color: Colors.white, fontSize: 17))),
          ],
        ),
        //drawer: Drawer(
        // child: Wrapper(widget: MenuWrapper()),
        // ),
        body: SafeArea(
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("lockers").snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Text("Loading...");
              }
              // Check if the icon was loaded successfully

              GeoPoint location;
              //print('here');
              var document = snapshot.data.docs.forEach((document) {
                if (document.exists) {
                  //print('found locker: ' + document['lockerName']);
                  location = document['lockerPosition'];
                  var latLng = LatLng(location.latitude, location.longitude);
                  markers.add(Marker(
                    markerId: MarkerId(document.id),
                    position: latLng,

                    onTap: () => MediaQuery.of(context).size.width < 800
                        ? _showBottomSheet(document)
                        : showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              Map<String, dynamic> map = document.data();
                              return CustomDialogBox(
                                map: map,
                                document: document,
                              );
                            }),
                    icon: customIcon, //BitmapDescriptor.defaultMarker
                  ));
                } else {
                  print('document does not exist');
                }
              });

              currentLocation == null
                  ? initial_location = LatLng(45.482831, 9.194336)
                  : initial_location = LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!);

              return GoogleMap(
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition:
                    CameraPosition(target: initial_location, zoom: 12.8),
                markers: markers,
              );
            },
          ),
        ));
  }

  _showBottomSheet(dynamic document) async {
    Map<String, dynamic> map = document.data();
    //A modal bottom sheet is an alternative to a menu or a dialog and prevents the user from interacting with the rest of the app.
    await showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (BuildContext context) {
          return Container(
              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
              height: 220,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${document['lockerName']} locker",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Address: ${document['lockerAddress']}",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Small cell fare: ${document['smallCellFare'].toString()}€/hour",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Large cell fare: ${document['largeCellFare'].toString()}€/hour",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BookingLockerWrapper((document))))
                              .then((_) {
                            Navigator.of(context)
                                .pop(); // Close the dialog box after returning from BookingLockerWrapper
                          });
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
                        child: Text("Book this locker".toUpperCase())),
                  ),
                  map.containsKey("urls") == true
                      ? Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ImageView(map: map),
                        )
                      : Container(),
                ],
              ));
        });
  }

  //check if GPS is enabled
  _check_permission() async {
    _serviceEnabled = await user_location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await user_location.requestService();
      if (!_serviceEnabled) {
        ok = false;
        return;
      }
    }

    // check if the user gave permission to our app to access his location
    _permissionGranted = await user_location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await user_location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        ok = false;
        return;
      }
    }
    return;
  }
}
