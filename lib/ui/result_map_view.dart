import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ResultMapView extends StatefulWidget {
  const ResultMapView({Key? key}) : super(key: key);

  @override
  _ResultMapViewState createState() => _ResultMapViewState();
}

class _ResultMapViewState extends State<ResultMapView> {
  GoogleMapController? myMapController;
  final Set<Marker> _markers = new Set();
  static const LatLng _mainLocation = const LatLng(6.655100, -1.546730);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Results of Contribution'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _mainLocation,
                  zoom: 15.0,
                ),
                markers: this.myMarker(),
                mapType: MapType.normal,
                onMapCreated: (controller) {
                  setState(() {
                    myMapController = controller;
                  });
                },
              ),
            ),
          ],
        ));
  }

  Set<Marker> myMarker() {
    setState(() {
      _markers.addAll([
        Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(_mainLocation.toString()),
          position: _mainLocation,
          infoWindow: InfoWindow(
            title: 'Historical City',
            snippet: '5 Star Rating',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      ]);
    });

    return _markers;
  }
}
