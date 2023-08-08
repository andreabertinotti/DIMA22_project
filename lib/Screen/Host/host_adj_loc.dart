import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pro/Screen/Host/host_add.dart';

class locationScreen extends StatefulWidget {
  locationScreen(String this.uid, property this.property_passed, {Key? key})
      : super(key: key);

  property property_passed;
  String uid;

  @override
  _locationScreenState createState() => _locationScreenState(property_passed);
}

class _locationScreenState extends State<locationScreen> {
  property property_passed;
  late LatLng googleMapsCenter = property_passed.coordinate;
  late GoogleMapController googleMapsController;
  bool _loadingButton = false;
  _locationScreenState(this.property_passed);
  late LatLng finalCoordinate;

  final List<Marker> _markers = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 38,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 20, 0),
              child: Text(
                'Is this the correct location\nof your property?',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 120, 20),
              child: Text(
                'if not adjust the marker on the map',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5, 20, 5, 5),
              child: Container(
                width: 350,
                height: 250,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Color(0xFF0B0B0B),
                    width: 2,
                  ),
                ),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: property_passed.coordinate, zoom: 17),
                  onMapCreated: (controller) {
                    final marker = Marker(
                      markerId: MarkerId('0'),
                      position: property_passed.coordinate,
                    );
                    _markers.add(marker);
                  },
                  markers: _markers.toSet(),
                  onCameraMove: (position) {
                    setState(() {
                      _markers.first = _markers.first
                          .copyWith(positionParam: position.target);
                      finalCoordinate = position.target;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(250, 75, 5, 0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance.collection('Location').add({
                      "uid": widget.uid,
                      "location": GeoPoint(
                          finalCoordinate.latitude, finalCoordinate.longitude),
                      "name": property_passed.name,
                      "price": property_passed.price,
                      "description": property_passed.description,
                      "hostMail": property_passed.hostMail,
                    });
                  });
                  Navigator.pop(context);
                },
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
