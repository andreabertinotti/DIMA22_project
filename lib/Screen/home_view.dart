import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../Social/create_post.dart';
import '../Utils/custom_dialog_box.dart';
import '../Utils/image_view.dart';
import '../Utils/wrapper.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Set<Marker> markers = Set();
  late BitmapDescriptor customIcon;
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
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("lockers").snapshots(),
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
                infoWindow: InfoWindow(
                    title: document['lockerName'],
                    snippet: document['lockerFare'].toString() + '€/hour'),
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

              print('position: ' + latLng.toString());
            } else {
              print('document does not exist');
            }
          });
          print('here 2');
          currentLocation == null
              ? initial_location = LatLng(45.478436, 9.226619)
              : initial_location = LatLng(
                  currentLocation!.latitude!, currentLocation!.longitude!);
          print('here 3');

          return GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition:
                CameraPosition(target: initial_location, zoom: 13),
            markers: markers,
          );
        },
      ),
    );
  }

  _showBottomSheet(dynamic document) async {
    Map<String, dynamic> map = document.data();
    //A modal bottom sheet is an alternative to a menu or a dialog and prevents the user from interacting with the rest of the app.
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                                  builder: (context) =>
                                      Wrapper(widget: CreatePost(document))));
                        },
                        color: Colors.orange,
                        textColor: Colors.white,
                        child: const Text("Create a reservation"),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "Locker's name: ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      document['lockerName'],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "euro/hour: ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      document['lockerFare'].toString(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Address: ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        document['lockerAddress'],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                map.containsKey("urls") == true
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ImageView(map: map),
                      )
                    : Container(),
              ],
            ),
          );
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
