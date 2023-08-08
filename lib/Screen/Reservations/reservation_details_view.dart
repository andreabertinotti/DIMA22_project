import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pro/Social/PostDetails/post_details_view.dart';

import '../../Models/user_model.dart';

class ReservationDetailsView extends StatefulWidget {
  final String reservationId;
  Map<String, dynamic> data;
  User? user;
  final String docId;

  ReservationDetailsView(this.reservationId,
      {Key? key, required this.data, required this.docId, required this.user})
      : super(key: key);

  @override
  _ReservationDetailsViewState createState() => _ReservationDetailsViewState();
}

class _ReservationDetailsViewState extends State<ReservationDetailsView> {
  int _currentIndex = 0;
  Set<Marker> markers = Set();
  late BitmapDescriptor customIcon;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    getIcons();
    super.initState();
  }

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.0), "assets/images/marker.png");
    setState(() {
      this.customIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Location")
                .doc(widget.reservationId)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Scaffold(
                  body: Container(
                    child: const Text('Loading Data...Please wait'),
                  ),
                );
              }
              final urlImages = snapshot.data['urls'];
              GeoPoint location;
              location = snapshot.data['location'];
              var latLng = LatLng(location.latitude, location.longitude);
              markers.add(Marker(
                markerId: MarkerId(widget.reservationId),
                position: latLng,
                icon: customIcon,
              ));
              return Scaffold(
                appBar: AppBar(
                  title: Text("Reservation Details"),
                  backgroundColor: Colors.amber,
                  actions: <Widget>[
                    widget.data['uid'] == widget.user!.uid
                        ? Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                //delete post
                                FirebaseFirestore.instance
                                    .collection("Post")
                                    .doc(widget.docId)
                                    .delete();
                                Navigator.pop(context, true);
                              },
                              child: Icon(
                                Icons.delete,
                                size: 26.0,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                body: ListView(
                  shrinkWrap: true,
                  /*mainAxisSize: MainAxisSize.max,*/
                  children: <Widget>[
                    PostDetailsView(
                        data: widget.data,
                        docId: widget.docId,
                        user: widget.user!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            snapshot.data['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(thickness: 5),
                    CarouselSlider.builder(
                        itemCount: urlImages.length,
                        itemBuilder: (BuildContext context, index, int) {
                          final urlImage = urlImages[index];
                          return buildImage(urlImage, index);
                        },
                        options: CarouselOptions(
                          height: 200,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: map<Widget>(urlImages, (index, url) {
                        return Container(
                          width: 10.0,
                          height: 10.0,
                          margin: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? Colors.blueAccent
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                    Divider(
                      thickness: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data['price'].toString() + '€/month',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 350,
                            child: Text(
                              snapshot.data['description'],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                              ),
                            )),
                      ],
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width: 250,
                              height: 150,
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
                                initialCameraPosition:
                                    CameraPosition(target: latLng, zoom: 15),
                                markers: markers,
                              )),
                        )
                      ],
                    )
                  ],
                ),
              );
            }));
  }

  Widget buildImage(String urlImage, int index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        color: Colors.grey,
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
        ),
      );
}
