import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_map/services/crimes_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:crime_map/widgets/c_app_bar.dart';
import 'package:location/location.dart';
import 'package:crime_map/widgets/form_dialog.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapboxMapController mapController;
  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );
  // Set<Marker> markers = {};

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 10)).then((value) {
      _goToUserPosition();
    });
    super.initState();
  }

  _goToUserPosition() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    _initialCameraPosition = CameraPosition(
      target: LatLng(_locationData.latitude, _locationData.longitude),
      zoom: 14,
    );

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        _initialCameraPosition,
      ),
    );
    setState(() {});
  }

  _getCrimes() {
    crimesService.getCrimes().listen((snapshot) async {
      _renderCrimes(snapshot.documents);
    });
  }

  _renderCrimes(documents) {
    for (var crime in documents) {
      GeoPoint location = crime['location'];
      print(crime);
      mapController.addSymbol(
        SymbolOptions(
          iconImage: _getMarkerImage(
            crime['report_number'],
          ),
          iconOpacity: 1,
          geometry: LatLng(location.latitude, location.longitude),
          iconSize: 0.1,
        ),
      );
    }
  }

  String _getMarkerImage(String number) {
    int reportNumber = int.tryParse(number) ?? 0;
    if (reportNumber < 5) {
      return "assets/images/marker-green.png";
    } else if (reportNumber >= 5 && reportNumber < 20) {
      return "assets/images/marker-orange.png";
    } else {
      return "assets/images/marker-red.png";
    }
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _getCrimes();
    // mapController.addListener(_onMapChanged);
  }

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
      // accessToken: Constants.mapboxApiKey,
      onMapCreated: onMapCreated,
      initialCameraPosition: _initialCameraPosition,
      trackCameraPosition: true,
      compassEnabled: true,
      myLocationEnabled: true,
      myLocationRenderMode: MyLocationRenderMode.GPS,
    );

    return Scaffold(
      appBar: CAppBar(
        title: "CrimeMap",
        searchbar: _buildSearchBar(),
      ),
      body: SafeArea(child: mapboxMap),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCrimeDialog,
        label: Text("Add crime"),
        icon: Icon(Ionicons.ios_add),
      ),
    );
  }

  _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Octicons.search, size: 20, color: Colors.black45),
          hintText: "Search crimes by location...",
        ),
      ),
    );
  }

  Future<void> _showAddCrimeDialog() async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AddCrimeDialog(
          title: "Add crime",
        );
      },
    );
  }
}
