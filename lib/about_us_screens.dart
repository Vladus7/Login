import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class UsScreen extends StatefulWidget {
  @override
  _UsScreenState createState() => _UsScreenState();
}

class _UsScreenState extends State<UsScreen> {
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("About us"),
        ),
        body: ListView( children: <Widget>[
          ListTile(
          leading: Icon(Icons.play_arrow, color: Colors.red,),
          title: Text('Video'),
          onTap: () {
            _launchURL('https://www.youtube.com/watch?v=tMfpJB7Q91c');
          },
        ),
        ListTile(
          title: Text('Map'),
          leading: Icon(Icons.map,  color: Colors.red,),
          onTap: () {
            Navigator.of(context).pushNamed('/map_screen');
          },
        ),]),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;
  var currentLocation;

  _getLocation() async {
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }
  }

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  void Buildmap(GoogleMapController controller) {
    mapController = controller;
    mapController.addMarker(
      MarkerOptions(
        position: LatLng(37.422034, -122.084187),
        infoWindowText: InfoWindowText('My Office','Googleplex'),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    mapController.addMarker(
      MarkerOptions(
        position: LatLng(currentLocation["latitude"], currentLocation["longitude"]),
        infoWindowText: InfoWindowText('My location', 'Home'),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
      ),
      body: GoogleMap(
        onMapCreated: Buildmap,
      ),
    );
  }
}