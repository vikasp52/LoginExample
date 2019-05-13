import 'dart:async';
import 'package:flutter_assignment/Util/FaceBookSignInUtil.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'LoginPage.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Completer<GoogleMapController> _controller = Completer();
  static double lat = 0.0, lan = 0.0;
  bool isLoading = true;

  _getCurrentLocation() async {
    var location = Location();
    try {
      var currentLocation = await location.getLocation();
      setState(() {
        lat = currentLocation.latitude;
        lan = currentLocation.longitude;
      });

      print(currentLocation.latitude);
      print(currentLocation.longitude);
      isLoading = false;
    } on Exception {
      print("There is some problem");
    }
  }

  Future<void> _randomLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  @override
  void initState() {
    _getCurrentLocation();
    _firebaseMessaging.getToken().then((token){
      print("Token is: $token");
    });
    super.initState();
  }

  static final CameraPosition _kLake = CameraPosition(
      target: LatLng(28.7041, 77.1025),
      zoom: 19.151926040649414);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(lat, lan),
    zoom: 17.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Map'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () async {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> MyLoginPage()));
                await FaceBookSignInUtil.signOutFromFacebook(context);
              }),
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: _randomLocation,
        label: Text('Go to Random Location'),
        icon: Icon(Icons.local_airport),
      ),
    );
  }
}