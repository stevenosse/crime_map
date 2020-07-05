import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_map/models/place_response.dart';
import 'package:crime_map/services/crimes_service.dart';
import 'package:crime_map/services/maps_service.dart';
import 'package:crime_map/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> mapCrimeSymbols = {};
  MapboxMapController mapController;
  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 10)).then((value) {
      _goToUserPosition();
    });
    super.initState();
  }

  _goToUserPosition() async {
    LocationData _locationData = await Helper.getCurrentPosition();
    if (_locationData != null) {
      _initialCameraPosition = CameraPosition(
        target: LatLng(_locationData.latitude, _locationData.longitude),
        zoom: 8,
      );

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          _initialCameraPosition,
        ),
      );
      setState(() {});
    }
  }

  _getCrimes() {
    crimesService.getCrimes().listen((snapshot) async {
      print("received data");
      _renderCrimes(snapshot.documents);
    });
  }

  _renderCrimes(List<DocumentSnapshot> documents) async {
    mapCrimeSymbols.clear();
    for (var crime in documents) {
      GeoPoint location = crime.data['location'];
      final symbol = await mapController.addSymbol(
        SymbolOptions(
          iconImage: _getMarkerImage(
            crime['report_number'],
          ),
          iconOpacity: 1,
          geometry: LatLng(location?.latitude ?? 0, location?.longitude ?? 0),
          iconSize: 0.1,
        ),
      );

      mapCrimeSymbols.addAll({symbol.id: crime.data['report_number']});
    }
    setState(() {});
  }

  String _getMarkerImage(int reportNumber) {
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
    mapController.onSymbolTapped.add(_onSymbolTapped);
    _getCrimes();
    // mapController.addListener(_onMapChanged);
  }

  _onSymbolTapped(Symbol symbol) {
    Helper.notify(
      context,
      message:
          "There were ${mapCrimeSymbols[symbol.id]} crime(s) reported here.",
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
      // accessToken: Constants.mapboxApiKey,
      onMapCreated: onMapCreated,
      initialCameraPosition: _initialCameraPosition,
      trackCameraPosition: true,
      compassEnabled: true,
      zoomGesturesEnabled: true,
      myLocationEnabled: false,
      myLocationRenderMode: MyLocationRenderMode.GPS,
    );

    return Scaffold(
      key: _scaffoldKey,
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
      child: TypeAheadField(
        suggestionsCallback: (pattern) async {
          if (pattern.isEmpty) return <Features>[];
          PlaceResponse response = await mapsService.getPlaces(pattern);
          return response.features;
        },
        noItemsFoundBuilder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "No match found",
              style: TextStyle(fontSize: 12.0, color: Colors.black45),
            ),
          );
        },
        errorBuilder: (context, error) {
          print(error);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "An error occured.",
              style: TextStyle(fontSize: 12.0, color: Colors.redAccent),
            ),
          );
        },
        itemBuilder: (context, Features suggestion) {
          return ListTile(
            leading: Icon(Octicons.location),
            title: Text(suggestion.text),
            subtitle: Text(
              suggestion?.context
                      ?.firstWhere((s) => s.id.contains("country"))
                      ?.text ??
                  "-",
            ),
          );
        },
        onSuggestionSelected: (Features suggestion) {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  suggestion.geometry.coordinates.last,
                  suggestion.geometry.coordinates.first,
                ),
                zoom: 10,
              ),
            ),
          );
        },
        textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Octicons.search, size: 20, color: Colors.black45),
            hintText: "Search crimes by location...",
          ),
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
    ).then((crimeAdded) {
      if (crimeAdded != null) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              crimeAdded
                  ? "The crime was added successfully"
                  : "Sorry, we were not able to save the crime.",
            ),
            backgroundColor: crimeAdded ? Colors.green : Colors.red,
            action: SnackBarAction(
              label: "OK",
              textColor: Colors.white,
              onPressed: () {
                _scaffoldKey.currentState.hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });
  }
}
